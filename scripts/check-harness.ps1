[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$failures = [System.Collections.Generic.List[string]]::new()

function Add-HarnessFailure {
    param([Parameter(Mandatory)][string]$Message)
    $script:failures.Add($Message)
}

function Get-RepositoryRelativePath {
    param([Parameter(Mandatory)][string]$Path)
    $rootUri = [Uri]::new(($script:repositoryRoot.TrimEnd('\') + '\'))
    $pathUri = [Uri]::new([System.IO.Path]::GetFullPath($Path))
    return [Uri]::UnescapeDataString($rootUri.MakeRelativeUri($pathUri).ToString()).Replace('/', '\')
}

function Get-SectionContent {
    param(
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string[]]$Names
    )

    foreach ($name in $Names) {
        $pattern = '(?ms)^#{1,6}\s+' + [regex]::Escape($name) + '\s*$\r?\n(?<body>.*?)(?=^#{1,6}\s+|\z)'
        $match = [regex]::Match($Content, $pattern, [Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if ($match.Success) {
            return $match.Groups['body'].Value.Trim()
        }
    }
    return $null
}

function Test-SemanticSections {
    param(
        [Parameter(Mandatory)][string]$RelativePath,
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][hashtable]$SectionGroups
    )

    foreach ($responsibility in $SectionGroups.Keys) {
        $section = Get-SectionContent -Content $Content -Names $SectionGroups[$responsibility]
        if ($null -eq $section -or [string]::IsNullOrWhiteSpace($section)) {
            Add-HarnessFailure "$RelativePath must cover non-empty '$responsibility' content."
        }
    }
}

function Get-Frontmatter {
    param(
        [Parameter(Mandatory)][string]$RelativePath,
        [Parameter(Mandatory)][string]$Content
    )

    $match = [regex]::Match($Content, '(?s)\A(?:\uFEFF)?---\s*\r?\n(?<body>.*?)\r?\n---\s*(?:\r?\n|\z)')
    if (-not $match.Success) {
        Add-HarnessFailure "$RelativePath must begin with YAML frontmatter."
        return $null
    }

    $metadata = @{}
    foreach ($line in ($match.Groups['body'].Value -split '\r?\n')) {
        if ($line -match '^\s*(?<key>[A-Za-z][A-Za-z0-9_-]*)\s*:\s*(?<value>.*?)\s*$') {
            if ($metadata.ContainsKey($matches['key'])) {
                Add-HarnessFailure "$RelativePath has duplicate metadata '$($matches['key'])'."
            }
            else {
                $metadata[$matches['key']] = $matches['value'].Trim('"', "'")
            }
        }
    }
    return $metadata
}

function Get-Ids {
    param(
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string]$Prefix
    )
    return @([regex]::Matches($Content, "(?m)\b$([regex]::Escape($Prefix))-\d{3}\b") | ForEach-Object Value | Sort-Object -Unique)
}

function Test-TaskDocument {
    param(
        [Parameter(Mandatory)][string]$RelativePath,
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string[]]$SpecRequirementIds,
        [Parameter(Mandatory)][string[]]$SpecAcceptanceIds
    )

    Test-SemanticSections -RelativePath $RelativePath -Content $Content -SectionGroups @{
        'Test Coverage Matrix' = @('Test Coverage Matrix')
        'Gate Check Commands' = @('Gate Check Commands')
        'Execution Plan' = @('Execution Plan')
        'Acceptance Criteria to Task Traceability' = @('Acceptance Criteria to Task Traceability')
    }

    $taskMatches = @([regex]::Matches($Content, '(?ms)^##\s+(?<id>TASK-\d{3})\s+[^\r\n]+\r?\n(?<body>.*?)(?=^##\s+TASK-\d{3}\s+|^##\s+|\z)'))
    if ($taskMatches.Count -eq 0) {
        Add-HarnessFailure "$RelativePath must contain at least one TASK-xxx block."
        return
    }

    $taskIds = @($taskMatches | ForEach-Object { $_.Groups['id'].Value })
    $coveredAcceptanceIds = @()
    $duplicates = @($taskIds | Group-Object | Where-Object Count -gt 1)
    foreach ($duplicate in $duplicates) {
        Add-HarnessFailure "$RelativePath has duplicate task ID $($duplicate.Name)."
    }

    for ($index = 0; $index -lt $taskIds.Count; $index++) {
        $expected = 'TASK-{0:D3}' -f ($index + 1)
        if ($taskIds[$index] -ne $expected) {
            Add-HarnessFailure "$RelativePath task sequence expected $expected but found $($taskIds[$index])."
        }
    }

    foreach ($taskMatch in $taskMatches) {
        $taskId = $taskMatch.Groups['id'].Value
        $body = $taskMatch.Groups['body'].Value
        foreach ($field in @('Objective', 'Scope', 'Where', 'Requirements', 'Acceptance Criteria', 'Dependencies', 'Done when', 'Tests', 'Verify')) {
            if ($body -notmatch "(?mi)^$([regex]::Escape($field)):\s*(?:\r?\n|\S)") {
                Add-HarnessFailure "$RelativePath $taskId is missing field '${field}:'."
            }
        }

        $taskRequirements = @(Get-Ids -Content $body -Prefix 'REQ')
        $taskAcceptance = @(Get-Ids -Content $body -Prefix 'AC')
        $coveredAcceptanceIds += $taskAcceptance
        if ($taskRequirements.Count -eq 0 -and $taskAcceptance.Count -eq 0) {
            $requirementsField = [regex]::Match($body, '(?ms)^Requirements:\s*(?<value>.*?)(?=^[A-Za-z][A-Za-z ]+:|\z)')
            if (-not $requirementsField.Success -or $requirementsField.Groups['value'].Value -notmatch '(?i)\bdesign\b') {
                Add-HarnessFailure "$RelativePath $taskId must trace a requirement/AC or explicit design item."
            }
        }
        foreach ($id in $taskRequirements) {
            if ($SpecRequirementIds -notcontains $id) {
                Add-HarnessFailure "$RelativePath $taskId references unknown requirement $id."
            }
        }
        foreach ($id in $taskAcceptance) {
            if ($SpecAcceptanceIds -notcontains $id) {
                Add-HarnessFailure "$RelativePath $taskId references unknown acceptance criterion $id."
            }
        }

        $dependencyMatch = [regex]::Match($body, '(?ms)^Dependencies:\s*(?<value>.*?)(?=^[A-Za-z][A-Za-z ]+:|\z)')
        if ($dependencyMatch.Success) {
            foreach ($dependency in (Get-Ids -Content $dependencyMatch.Groups['value'].Value -Prefix 'TASK')) {
                if ($taskIds -notcontains $dependency) {
                    Add-HarnessFailure "$RelativePath $taskId references missing dependency $dependency."
                }
                elseif ([array]::IndexOf($taskIds, $dependency) -ge [array]::IndexOf($taskIds, $taskId)) {
                    Add-HarnessFailure "$RelativePath $taskId has invalid future/self dependency $dependency."
                }
            }
        }

        $verifyMatch = [regex]::Match($body, '(?ms)^Verify:\s*\r?\n?\s*\x60(?<command>[^\x60]+)\x60')
        if (-not $verifyMatch.Success -or $verifyMatch.Groups['command'].Value -match '<|>|TODO|TBD') {
            Add-HarnessFailure "$RelativePath $taskId must use a concrete inline-code Verify command."
        }

        $doneMatch = [regex]::Match($body, '(?ms)^Done when:\s*(?<value>.*?)(?=^[A-Za-z][A-Za-z ]+:|\z)')
        if (-not $doneMatch.Success -or [string]::IsNullOrWhiteSpace($doneMatch.Groups['value'].Value) -or $doneMatch.Groups['value'].Value -match '<|TODO|TBD') {
            Add-HarnessFailure "$RelativePath $taskId must have concrete binary Done when content."
        }
    }

    foreach ($acceptanceId in $SpecAcceptanceIds) {
        if ($coveredAcceptanceIds -notcontains $acceptanceId) {
            Add-HarnessFailure "$RelativePath does not cover acceptance criterion $acceptanceId."
        }
    }
}

function Test-ValidationDocument {
    param(
        [Parameter(Mandatory)][string]$RelativePath,
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string[]]$SpecAcceptanceIds
    )

    if ($Content -match '(?i)<[^>]+>|\bTODO\b|\bTBD\b|placeholder') {
        Add-HarnessFailure "$RelativePath contains placeholder content."
    }

    Test-SemanticSections -RelativePath $RelativePath -Content $Content -SectionGroups @{
        'Execution Metadata' = @('Execution Metadata')
        'Task Completion' = @('Task Completion')
        'Acceptance Criteria Evidence' = @('Acceptance Criteria Evidence')
        'Verification / Gate Results' = @('Verification / Gate Results')
        'Reviewer Findings' = @('Reviewer Findings')
        'Deviations' = @('Deviations')
        'Fix / Re-verification Iterations' = @('Fix / Re-verification Iterations')
        'Final Verdict' = @('Final Verdict')
    }

    $verdictSection = Get-SectionContent -Content $Content -Names @('Final Verdict')
    $verdicts = @([regex]::Matches([string]$verdictSection, '(?mi)^\s*(?:[-*]\s*)?(?:Verdict:\s*)?(PASS|FAIL)\s*$') | ForEach-Object { $_.Groups[1].Value })
    if ($verdicts.Count -ne 1) {
        Add-HarnessFailure "$RelativePath must contain exactly one final verdict PASS or FAIL."
    }

    $evidenceSection = Get-SectionContent -Content $Content -Names @('Acceptance Criteria Evidence')
    foreach ($acceptanceId in $SpecAcceptanceIds) {
        if ([string]$evidenceSection -notmatch "\b$([regex]::Escape($acceptanceId))\b") {
            Add-HarnessFailure "$RelativePath has no evidence entry for $acceptanceId."
        }
    }

    if ($verdicts.Count -eq 1 -and $verdicts[0] -eq 'PASS') {
        if ($Content -match '(?mi)\bGAP\b|\bBLOCKER\b\s*(?!:\s*(?:None|Nenhum|0)\b)') {
            Add-HarnessFailure "$RelativePath cannot be PASS while GAP/blocker evidence remains."
        }
    }
}

$requiredPaths = @(
    'AGENTS.md',
    'specs/README.md',
    'specs/_templates/spec-template.md',
    'specs/_templates/design-template.md',
    'specs/_templates/tasks-template.md',
    'specs/_templates/validation-template.md',
    'docs/README.md',
    'docs/architecture.md',
    'docs/architecture/open-decisions.md',
    'docs/domain/README.md',
    'docs/domain/open-decisions.md',
    'docs/product/README.md',
    'docs/methodology/development-methodology.md',
    'contracts/README.md',
    '.codex/config.toml',
    '.codex/agents/reviewer.toml',
    '.codex/agents/verifier.toml',
    '.agents/skills/backend-development/SKILL.md',
    '.agents/skills/frontend-development/SKILL.md',
    '.agents/skills/quality-assurance/SKILL.md'
)

foreach ($relativePath in $requiredPaths) {
    if (-not (Test-Path -LiteralPath (Join-Path $repositoryRoot $relativePath) -PathType Leaf)) {
        Add-HarnessFailure "Required harness document is missing: $relativePath"
    }
}

foreach ($legacyRoot in @('docs-v1', 'docs-v2', 'arch')) {
    if (Test-Path -LiteralPath (Join-Path $repositoryRoot $legacyRoot)) {
        Add-HarnessFailure "Legacy root must be removed: $legacyRoot"
    }
}

$agentsPath = Join-Path $repositoryRoot 'AGENTS.md'
$agentsBytes = 0
$agentsLimit = 20KB
if (Test-Path -LiteralPath $agentsPath -PathType Leaf) {
    $agentsBytes = [Text.Encoding]::UTF8.GetByteCount([IO.File]::ReadAllText($agentsPath))
    if ($agentsBytes -gt $agentsLimit) {
        Add-HarnessFailure "AGENTS.md is $agentsBytes bytes; the limit is $agentsLimit bytes."
    }
}

$specsRoot = Join-Path $repositoryRoot 'specs'
$allowedPackageMarkdown = @('spec.md', 'design.md', 'tasks.md', 'validation.md')
$packageDirectories = @(
    if (Test-Path -LiteralPath $specsRoot -PathType Container) {
        Get-ChildItem -LiteralPath $specsRoot -Directory | Where-Object Name -ne '_templates'
    }
)

foreach ($packageDirectory in $packageDirectories) {
    $packageRelativePath = Get-RepositoryRelativePath $packageDirectory.FullName
    foreach ($markdownFile in Get-ChildItem -LiteralPath $packageDirectory.FullName -File -Filter '*.md') {
        if ($allowedPackageMarkdown -notcontains $markdownFile.Name) {
            Add-HarnessFailure "Unknown package Markdown '$($markdownFile.Name)' in $packageRelativePath. Allowed: $($allowedPackageMarkdown -join ', ')."
        }
    }

    $specPath = Join-Path $packageDirectory.FullName 'spec.md'
    if (-not (Test-Path -LiteralPath $specPath -PathType Leaf)) {
        Add-HarnessFailure "Specification package is missing spec.md: $packageRelativePath"
        continue
    }

    $specRelativePath = Get-RepositoryRelativePath $specPath
    $specContent = [IO.File]::ReadAllText($specPath)
    $metadata = Get-Frontmatter -RelativePath $specRelativePath -Content $specContent
    if ($null -eq $metadata) { continue }

    foreach ($field in @('id', 'version', 'status', 'scope')) {
        if (-not $metadata.ContainsKey($field) -or [string]::IsNullOrWhiteSpace($metadata[$field])) {
            Add-HarnessFailure "$specRelativePath requires non-empty metadata '$field'."
        }
    }
    if ($metadata.ContainsKey('id')) {
        if ($metadata['id'] -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') {
            Add-HarnessFailure "$specRelativePath id must be lowercase kebab-case."
        }
        elseif ($metadata['id'] -ne $packageDirectory.Name) {
            Add-HarnessFailure "$specRelativePath id '$($metadata['id'])' must match directory '$($packageDirectory.Name)'."
        }
    }
    if ($metadata.ContainsKey('version') -and $metadata['version'] -notmatch '^[1-9]\d*$') {
        Add-HarnessFailure "$specRelativePath version must be a positive integer."
    }
    if ($metadata.ContainsKey('status') -and @('Draft', 'Ready', 'Superseded') -notcontains $metadata['status']) {
        Add-HarnessFailure "$specRelativePath status must be Draft, Ready or Superseded."
    }
    if ($metadata.ContainsKey('scope') -and @('Small', 'Medium', 'Large', 'Complex') -notcontains $metadata['scope']) {
        Add-HarnessFailure "$specRelativePath scope must be Small, Medium, Large or Complex."
    }

    Test-SemanticSections -RelativePath $specRelativePath -Content $specContent -SectionGroups @{
        'Problem Statement' = @('Problem Statement')
        'Goals / Objective' = @('Goals / Objective', 'Goals', 'Objective')
        'In scope' = @('In Scope', 'In scope')
        'Out of scope' = @('Out of Scope', 'Out of scope')
        'Assumptions & Open Questions' = @('Assumptions & Open Questions', 'Assumptions and Open Questions')
        'Requirements' = @('Requirements')
        'Acceptance Criteria' = @('Acceptance Criteria')
        'Edge Cases' = @('Edge Cases')
        'Applicable Domain Rules' = @('Applicable Domain Rules')
        'Affected Boundaries' = @('Affected Boundaries')
        'Failures and Validation' = @('Failures and Validation')
        'Security and Authorization' = @('Security and Authorization')
        'Persistence and Migrations' = @('Persistence and Migrations')
        'Contract Impact' = @('Contract Impact')
        'Requirement Traceability' = @('Requirement Traceability')
        'Success Criteria' = @('Success Criteria')
    }

    $requirementIds = @(Get-Ids -Content $specContent -Prefix 'REQ')
    $acceptanceIds = @(Get-Ids -Content $specContent -Prefix 'AC')
    if ($requirementIds.Count -eq 0) { Add-HarnessFailure "$specRelativePath must define REQ-xxx identifiers." }
    if ($acceptanceIds.Count -eq 0) { Add-HarnessFailure "$specRelativePath must define AC-xxx identifiers." }

    $designPath = Join-Path $packageDirectory.FullName 'design.md'
    $tasksPath = Join-Path $packageDirectory.FullName 'tasks.md'
    $validationPath = Join-Path $packageDirectory.FullName 'validation.md'
    $status = if ($metadata.ContainsKey('status')) { $metadata['status'] } else { '' }

    if ($status -eq 'Ready') {
        foreach ($requiredPackageFile in @($designPath, $tasksPath)) {
            if (-not (Test-Path -LiteralPath $requiredPackageFile -PathType Leaf)) {
                Add-HarnessFailure "$specRelativePath is Ready but missing $([IO.Path]::GetFileName($requiredPackageFile))."
            }
        }
        $openSection = Get-SectionContent -Content $specContent -Names @('Assumptions & Open Questions', 'Assumptions and Open Questions')
        if ([string]$openSection -notmatch '(?mi)\bNone\b|\bNenhuma?s?\b') {
            Add-HarnessFailure "$specRelativePath is Ready but material open questions are not explicitly None."
        }

        $authoritySection = Get-SectionContent -Content $specContent -Names @('Applicable Domain Rules')
        foreach ($linkMatch in [regex]::Matches([string]$authoritySection, '\[[^\]]*\]\((?<target>[^)]+)\)')) {
            $target = ($linkMatch.Groups['target'].Value.Trim() -split '[?#]', 2)[0]
            if ([string]::IsNullOrWhiteSpace($target) -or $target -match '^[A-Za-z][A-Za-z0-9+.-]*:') { continue }
            $resolvedTarget = [IO.Path]::GetFullPath((Join-Path $packageDirectory.FullName ([Uri]::UnescapeDataString($target).Replace('/', '\'))))
            if (Test-Path -LiteralPath $resolvedTarget -PathType Leaf) {
                $authorityContent = [IO.File]::ReadAllText($resolvedTarget)
                if ($authorityContent -match '(?mi)^\s*(?:>\s*)?\*\*Status:\*\*\s*(?:Draft|Open)\b') {
                    Add-HarnessFailure "$specRelativePath uses Draft/Open authority in Applicable Domain Rules: $target"
                }
            }
        }
    }

    if (Test-Path -LiteralPath $designPath -PathType Leaf) {
        $designRelativePath = Get-RepositoryRelativePath $designPath
        $designContent = [IO.File]::ReadAllText($designPath)
        Test-SemanticSections -RelativePath $designRelativePath -Content $designContent -SectionGroups @{
            'Summary / Architecture Overview' = @('Summary / Architecture Overview', 'Architecture Overview', 'Summary')
            'Requirement Mapping' = @('Requirement Mapping')
            'Implementation Approach' = @('Implementation Approach')
            'Affected Boundaries' = @('Affected Boundaries')
            'Code Reuse / Existing Patterns' = @('Code Reuse / Existing Patterns', 'Code Reuse', 'Existing Patterns')
            'Components / Responsibilities' = @('Components / Responsibilities', 'Components and Responsibilities')
            'Interfaces' = @('Interfaces')
            'Data Models' = @('Data Models')
            'Contract/API Changes' = @('Contract/API Changes', 'Contract Changes', 'API Changes')
            'Persistence and Migrations' = @('Persistence and Migrations')
            'Error Handling Strategy' = @('Error Handling Strategy')
            'Security Considerations' = @('Security Considerations')
            'Verification Strategy' = @('Verification Strategy')
            'Risks and Mitigations' = @('Risks and Mitigations')
            'Rollback Considerations' = @('Rollback Considerations')
            'Tech Decisions' = @('Tech Decisions')
            'Open Decisions' = @('Open Decisions')
        }
        foreach ($acceptanceId in $acceptanceIds) {
            if ($designContent -notmatch "\b$([regex]::Escape($acceptanceId))\b") {
                Add-HarnessFailure "$designRelativePath does not map acceptance criterion $acceptanceId."
            }
        }
        foreach ($requirementId in $requirementIds) {
            if ($designContent -notmatch "\b$([regex]::Escape($requirementId))\b") {
                Add-HarnessFailure "$designRelativePath does not map requirement $requirementId."
            }
        }
        foreach ($designRequirementId in @(Get-Ids -Content $designContent -Prefix 'REQ')) {
            if ($requirementIds -notcontains $designRequirementId) {
                Add-HarnessFailure "$designRelativePath introduces unknown requirement $designRequirementId."
            }
        }
        foreach ($designAcceptanceId in @(Get-Ids -Content $designContent -Prefix 'AC')) {
            if ($acceptanceIds -notcontains $designAcceptanceId) {
                Add-HarnessFailure "$designRelativePath introduces unknown acceptance criterion $designAcceptanceId."
            }
        }
        if ($status -eq 'Ready') {
            $openDecisions = Get-SectionContent -Content $designContent -Names @('Open Decisions')
            if ([string]$openDecisions -notmatch '(?mi)\bNone\b|\bNenhuma?s?\b') {
                Add-HarnessFailure "$designRelativePath must declare Open Decisions: None before Ready."
            }
        }
    }

    if (Test-Path -LiteralPath $tasksPath -PathType Leaf) {
        $tasksContent = [IO.File]::ReadAllText($tasksPath)
        Test-TaskDocument -RelativePath (Get-RepositoryRelativePath $tasksPath) -Content $tasksContent -SpecRequirementIds $requirementIds -SpecAcceptanceIds $acceptanceIds
    }

    if (Test-Path -LiteralPath $validationPath -PathType Leaf) {
        if ($status -ne 'Ready') {
            Add-HarnessFailure "$(Get-RepositoryRelativePath $validationPath) exists but its specification status is not Ready."
        }
        Test-ValidationDocument -RelativePath (Get-RepositoryRelativePath $validationPath) -Content ([IO.File]::ReadAllText($validationPath)) -SpecAcceptanceIds $acceptanceIds
    }
}

$tomlFiles = @(Get-ChildItem -LiteralPath (Join-Path $repositoryRoot '.codex') -File -Recurse -Filter '*.toml')
$python = Get-Command python -ErrorAction SilentlyContinue
if ($tomlFiles.Count -gt 0 -and $null -eq $python) {
    Add-HarnessFailure 'Cannot validate TOML: python with standard-library tomllib is required.'
}
elseif ($null -ne $python) {
    $tomlParser = "import pathlib, sys, tomllib; tomllib.loads(pathlib.Path(sys.argv[1]).read_text(encoding='utf-8-sig'))"
    foreach ($tomlFile in $tomlFiles) {
        $previous = $ErrorActionPreference
        $ErrorActionPreference = 'SilentlyContinue'
        $output = & $python.Source -c $tomlParser $tomlFile.FullName 2>&1
        $exitCode = $LASTEXITCODE
        $ErrorActionPreference = $previous
        if ($exitCode -ne 0) {
            Add-HarnessFailure "Invalid TOML in $(Get-RepositoryRelativePath $tomlFile.FullName): $(($output | Out-String).Trim())"
        }
    }
}

$jsonFiles = @(
    foreach ($jsonRoot in @('.codex', '.agents')) {
        $absoluteRoot = Join-Path $repositoryRoot $jsonRoot
        if (Test-Path -LiteralPath $absoluteRoot -PathType Container) {
            Get-ChildItem -LiteralPath $absoluteRoot -File -Recurse -Filter '*.json'
        }
    }
)
foreach ($jsonFile in $jsonFiles) {
    $relativePath = Get-RepositoryRelativePath $jsonFile.FullName
    $json = [IO.File]::ReadAllText($jsonFile.FullName)
    if ([string]::IsNullOrWhiteSpace($json)) {
        Add-HarnessFailure "JSON file is empty: $relativePath"
        continue
    }
    try { $null = $json | ConvertFrom-Json }
    catch { Add-HarnessFailure "Invalid JSON in ${relativePath}: $($_.Exception.Message)" }
}

$skillsRoot = Join-Path $repositoryRoot '.agents/skills'
$skillFiles = @(Get-ChildItem -LiteralPath $skillsRoot -File -Recurse -Filter 'SKILL.md')
foreach ($skillFile in $skillFiles) {
    $relativePath = Get-RepositoryRelativePath $skillFile.FullName
    $lines = @([IO.File]::ReadAllLines($skillFile.FullName))
    if ($lines.Count -lt 4 -or $lines[0].Trim() -ne '---') {
        Add-HarnessFailure "Skill must begin with YAML frontmatter: $relativePath"
        continue
    }
    $frontmatterEnd = -1
    for ($index = 1; $index -lt $lines.Count; $index++) {
        if ($lines[$index].Trim() -eq '---') { $frontmatterEnd = $index; break }
    }
    if ($frontmatterEnd -lt 0) {
        Add-HarnessFailure "Skill frontmatter has no closing delimiter: $relativePath"
        continue
    }
    $frontmatter = $lines[1..($frontmatterEnd - 1)]
    foreach ($field in @('name', 'description')) {
        $matchesForField = @($frontmatter | Where-Object { $_ -match ('^' + $field + ':\s*.+$') })
        if ($matchesForField.Count -ne 1) {
            Add-HarnessFailure "Skill frontmatter must contain one non-empty '$field' field: $relativePath"
        }
    }
}

$markdownFiles = [Collections.Generic.List[IO.FileInfo]]::new()
if (Test-Path -LiteralPath $agentsPath -PathType Leaf) { $markdownFiles.Add((Get-Item $agentsPath)) }
foreach ($markdownRoot in @('.agents', '.codex', 'specs', 'docs', 'contracts', 'evals')) {
    $absoluteRoot = Join-Path $repositoryRoot $markdownRoot
    if (Test-Path -LiteralPath $absoluteRoot -PathType Container) {
        foreach ($file in Get-ChildItem -LiteralPath $absoluteRoot -File -Recurse -Filter '*.md') {
            $markdownFiles.Add($file)
        }
    }
}

$markdownLinkPattern = '!?' + '\[[^\]]*\]' + '\((?<target>[^)]+)\)'
foreach ($markdownFile in $markdownFiles) {
    $content = [IO.File]::ReadAllText($markdownFile.FullName)
    foreach ($match in [regex]::Matches($content, $markdownLinkPattern)) {
        $target = $match.Groups['target'].Value.Trim()
        if ($target.StartsWith('<') -and $target.Contains('>')) {
            $target = $target.Substring(1, $target.IndexOf('>') - 1)
        }
        else { $target = ($target -split '\s+')[0] }
        if ([string]::IsNullOrWhiteSpace($target) -or $target.StartsWith('#') -or $target -match '^[A-Za-z][A-Za-z0-9+.-]*:') { continue }
        $targetWithoutFragment = ($target -split '[?#]', 2)[0]
        if ([string]::IsNullOrWhiteSpace($targetWithoutFragment)) { continue }
        $decodedTarget = [Uri]::UnescapeDataString($targetWithoutFragment).Replace('/', '\')
        $resolvedTarget = [IO.Path]::GetFullPath((Join-Path $markdownFile.DirectoryName $decodedTarget))
        if (-not (Test-Path -LiteralPath $resolvedTarget)) {
            Add-HarnessFailure "Broken local Markdown link in $(Get-RepositoryRelativePath $markdownFile.FullName): $target"
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Error ("Harness validation failed with {0} error(s):" -f $failures.Count) -ErrorAction Continue
    foreach ($failure in $failures) { Write-Error " - $failure" -ErrorAction Continue }
    exit 1
}

Write-Host ("Harness validation passed: {0} package(s), {1} TOML, {2} JSON, {3} skills, {4} Markdown files; AGENTS.md {5}/{6} bytes." -f $packageDirectories.Count, $tomlFiles.Count, $jsonFiles.Count, $skillFiles.Count, $markdownFiles.Count, $agentsBytes, $agentsLimit)
exit 0
