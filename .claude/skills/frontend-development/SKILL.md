---
name: frontend-development
description: Implementa, altera, corrige e revisa codigo de interface do usuario conforme um package Ready aplicavel em specs/ ou uma solicitacao explicita do usuario. Use para arquitetura de frontend, formularios, estados de UI, acessibilidade, seguranca no browser, performance e testes unitarios ou de integracao de frontend, independentemente de framework. Detecte as tecnologias do boundary a partir do repositorio e carregue todas as skills de overlay que existirem para elas; quando nao existir nenhuma, aplique conhecimento geral daquela tecnologia apenas para idiomas e declare isso. Nao use para jornadas end-to-end completas no browser; encaminhe-as para quality-assurance.
---

# Frontend Development

Use esta skill para mudanças e revisões no boundary de interface do usuário.
`CLAUDE.md` governa o gate de specs, RPI, arquitetura, segurança, validação e
conclusão.

Quando existir package Ready aplicável, Research deve consumir `spec.md`,
`design.md` e `tasks.md`, além do contrato aplicável. Sem ele, use a solicitação
explícita do usuário e as autoridades aceitas do repositório sem inventar
comportamento de produto. No caminho dirigido por package, o Plan local refina
apenas passos operacionais e não redefine os artefatos. No caminho diretamente
autorizado, ele também pode definir design frontend local, mapeamento contratual
e divisão do trabalho necessários ao pedido, mas não comportamento observável,
arquitetura transversal ou dependências sem autoridade. Após implementação
dirigida por package, a evidência pertence à validation independente em
`validation.md`.

Não infira requisitos de produto ausentes a partir de código, exemplos ou
material Draft. Se o trabalho depender de decisão material de domínio ou
arquitetura `Draft/Open`, pare até que autoridade humana a aceite no owner
durável apropriado; a solicitação de implementação não resolve essa decisão
silenciosamente.

## Workflow

1. A partir da Research concluída contra o package Ready aplicável ou a
   solicitação explícita do usuário, mapeie critérios de aceite frontend para
   estados e comportamentos observáveis.
2. Inspecione somente implementação, testes, manifesto de dependências, tipagem,
   configuração de build e configurações dos boundaries afetados.
3. Confirme que roteamento, estilização, biblioteca de testes e outras ferramentas
   necessárias já fazem parte da arquitetura e configuração.
4. Carregue a menor combinação de referências para os problemas técnicos
   concretos abaixo.
5. Mantenha componentes e feature code isolados do transporte, preservando type
   safety, acessibilidade e estados de UI exigidos.
6. Use testes unitários para lógica isolada e integração para colaboração entre
   componentes, hooks, estado e data access. Encaminhe jornadas completas no
   browser para `quality-assurance`.
7. Execute os comandos de validação que o `.claude/validation.json` declara para
   o boundary afetado, exatamente como escritos, e aplique os resultados a cada
   critério de aceite e caminho de falha aplicável.

## Stack Overlay

Esta skill cobre preocupações que valem independentemente do framework:
arquitetura, formulários, estados de UI, acessibilidade, segurança, performance
e testes. Ela não carrega os idiomas de uma stack específica.

Determine as tecnologias do boundary afetado a partir do próprio repositório e
procure um overlay correspondente. Linguagem, framework, roteamento e estilização
são overlays separados; carregue todos os que existirem.

- Quando existir overlay, carregue-o. Seus idiomas são autoridade do repositório.
- Quando não existir, aplique seu próprio conhecimento daquela tecnologia e
  declare isso: nomeie a tecnologia e registre que os idiomas vêm de
  conhecimento geral, não de autoridade do repositório.

O fallback cobre apenas idiomas. Ele nunca autoriza dependência, escolha de
biblioteca, padrão arquitetural, ferramenta ou comportamento observável. Esta
skill, o `CLAUDE.md` e a arquitetura aceita continuam governando o trabalho sem
alteração, com ou sem overlay.

A referência de concern define a regra; o overlay define o mecanismo. Se
parecerem divergir, a regra prevalece e a divergência é reportada.

## Reference Loading Rules

Não leia todas as referências nem use `README.md` como router intermediário.
Carregue somente os arquivos diretamente envolvidos; links relacionados dentro
de uma referência não devem ser seguidos automaticamente.

### Review Strategy

Comece pelo `review-checklist.md` do domínio relevante e consulte uma referência
detalhada somente quando um item concreto exigir esclarecimento.

---

## Architecture

- `app/`, feature-first structure, `shared/`, file placement e feature public API:
  [project-structure.md](references/architecture/project-structure.md)

- Components/hooks/model/repository responsibilities, dependency direction e necessidade de camadas:
  [layered-architecture.md](references/architecture/layered-architecture.md)

- Local, Context, server, form, URL, global e derived state ownership:
  [state-placement.md](references/architecture/state-placement.md)

- Repository, HTTP client, external contracts, mapping e transport boundaries:
  [data-access.md](references/architecture/data-access.md)

- Routes, path/search params, URL state, navigation, redirects, not-found e route protection:
  [routing.md](references/architecture/routing.md)

- Revisão consolidada de arquitetura:
  [review-checklist.md](references/architecture/review-checklist.md)

[HARD RULE] Não carregue todas as referências de architecture por padrão.

## Forms

- Draft editável, initial/default values, reset, dirty/touched, conditional fields e collections:
  [form-state.md](references/forms/form-state.md)

- Field/cross-field rules, schema, timing, optional values e async validation:
  [validation.md](references/forms/validation.md)

- Input mapping, pending, duplicate prevention, success/failure, create/update e retry:
  [submission.md](references/forms/submission.md)

- Field/form/server/submission errors, normalization, lifecycle e mensagens:
  [error-handling.md](references/forms/error-handling.md)

- Revisão consolidada de formulários:
  [review-checklist.md](references/forms/review-checklist.md)

[HARD RULE] Não carregue todas as referências de forms por padrão.

## UI States

- Pending, initial/background loading, refetch, spinner, skeleton e progress:
  [loading.md](references/ui-states/loading.md)

- Success sem conteúdo, collection empty, first-use e no-results:
  [empty.md](references/ui-states/empty.md)

- Falhas de página/seção/ação, partial failure, retry e recovery:
  [error.md](references/ui-states/error.md)

- Interação indisponível, capability semantics, pending conflicts e disabled controls:
  [disabled.md](references/ui-states/disabled.md)

- Revisão consolidada de UI states:
  [review-checklist.md](references/ui-states/review-checklist.md)

## Accessibility

- Native elements, button vs link, headings, landmarks, lists, tables e DOM semantic order:
  [semantic-html.md](references/accessibility/semantic-html.md)

- ARIA, accessible names/descriptions, semantic states, relationships, IDs e live regions:
  [aria.md](references/accessibility/aria.md)

- Keyboard operability, tab order, focus visibility, dialogs e programmatic focus:
  [keyboard-focus.md](references/accessibility/keyboard-focus.md)

- Labels, instructions, groups, validation feedback, field errors e form accessibility:
  [form-accessibility.md](references/accessibility/form-accessibility.md)

- Revisão consolidada de acessibilidade:
  [review-checklist.md](references/accessibility/review-checklist.md)

[HARD RULE] Não carregue todas as referências de accessibility por padrão.

## Security

Use estas referências para riscos específicos do frontend/browser. Autenticação e autorização reais continuam sendo responsabilidades do backend.

- Untrusted HTML, XSS-sensitive sinks, sanitization, dynamic URLs e executable content:
  [untrusted-content.md](references/security/untrusted-content.md)

- Frontend auth state, session credentials, logout, expiry e authorization boundary:
  [auth-session.md](references/security/auth-session.md)

- CORS, CSRF awareness, CSP, redirects, `postMessage`, windows e iframes:
  [browser-security.md](references/security/browser-security.md)

- Client-visible env, browser storage, URLs, logs, telemetry, PII e data minimization:
  [sensitive-data.md](references/security/sensitive-data.md)

- Third-party scripts, analytics, SDKs, widgets, dependencies e isolation:
  [third-party-code.md](references/security/third-party-code.md)

- Revisão consolidada de segurança frontend:
  [review-checklist.md](references/security/review-checklist.md)

[HARD RULE] Não carregue todas as referências de security por padrão.

[HARD RULE] Não altere autenticação, autorização, cookie policy, CSP ou backend security architecture incidentalmente; sinalize riscos fora do escopo e preserve o boundary responsável.

## Performance

[HARD RULE] Não otimize por suposição. Meça o problema antes de introduzir otimizações.

- Measurement-first workflow, profiling de browser, baseline e validação before/after:
  [measurement-profiling.md](references/performance/measurement-profiling.md)

- Custo de renderização, state boundaries, memoization e listas grandes:
  [rendering-performance.md](references/performance/rendering-performance.md)

- Initial JavaScript, dynamic imports, `lazy`, Suspense, chunks e dependency cost:
  [bundle-loading.md](references/performance/bundle-loading.md)

- Request waterfalls, duplicate fetching, cache, prefetch, pagination e mutation reconciliation:
  [data-network.md](references/performance/data-network.md)

- Core Web Vitals (`LCP`, `INP`, `CLS`), main-thread work, images, fonts e layout:
  [browser-performance.md](references/performance/browser-performance.md)

- Revisão consolidada de performance:
  [review-checklist.md](references/performance/review-checklist.md)

[HARD RULE] Antes de recomendar memoization manual em código novo, verifique no overlay de stack se o compilador do framework já elimina a necessidade.

[HARD RULE] Não carregue todas as referências de performance por padrão.

## Frontend Testing

Use estas referências para unit e integration testing do frontend.

[HARD RULE] Fluxos E2E completos pertencem à skill `quality-assurance`.

Classifique o teste pelo boundary definido na autoridade aplicável:

- lógica pura e regras isoladas → unit test frontend;
- colaboração entre componentes, hooks, estado e data-access → integration test frontend;
- fluxo completo atravessando browser e sistema → `quality-assurance`.

[HARD RULE] Relacione cada teste a um comportamento ou critério de aceite da spec ou solicitação explícita aplicável. Não crie testes apenas para aumentar cobertura numérica.

- Escolha do nível, distribuição de cenários, coverage e regression strategy:
  [test-strategy.md](references/testing/test-strategy.md)

- Pure logic, domain rules, transformations, reducers e comportamento isolado:
  [unit-testing.md](references/testing/unit-testing.md)

- Components, hooks, forms, routing, server state e data access funcionando juntos:
  [integration-testing.md](references/testing/integration-testing.md)

- Mocks, spies, stubs, fakes, network mocking e dependency boundaries:
  [mocking.md](references/testing/mocking.md)

- Promises, `waitFor`, pending, timers, retries, concurrency e race conditions:
  [async-testing.md](references/testing/async-testing.md)

- Revisão consolidada de testes frontend:
  [review-checklist.md](references/testing/review-checklist.md)

[HARD RULE] Não carregue todas as referências de testing por padrão.

---

## Project Rules

- Preserve type safety e a configuração de tipos existente; evite escapes de tipo quando
  houver alternativa segura.
- Reutilize tipos e componentes compatíveis e não duplique contratos da API sem
  necessidade.
- Mantenha regras de domínio e detalhes HTTP em seus boundaries arquiteturais.
- Referências não autorizam dependências, ferramentas ou padrões novos.

## Finalization

Siga os critérios de conclusão e comandos definidos em `CLAUDE.md`; relacione os
testes e resultados a cada critério frontend aplicável.
