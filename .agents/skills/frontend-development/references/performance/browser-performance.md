# Frontend Browser Performance

Referência para Core Web Vitals e custos de loading, responsiveness e layout no browser.

## Contents

- Core Web Vitals
- Field and lab data
- LCP
- INP
- CLS
- Main-thread work
- Assets
- Layout and rendering
- Fonts
- Images
- Third-party impact
- Responsibility boundaries

## Core Web Vitals

As Core Web Vitals atuais são:

```text
LCP
→ loading performance

INP
→ interaction responsiveness

CLS
→ visual stability
```

[HARD RULE] Use métricas como sinais de experiência, não como checklist de hacks.

Primeiro identifique qual parte da jornada produz o valor ruim.

## Recommended Thresholds

Para classificação "good" no 75º percentil de page visits:

```text
LCP ≤ 2.5s
INP ≤ 200ms
CLS ≤ 0.1
```

[HARD RULE] Não transforme esses thresholds globais em garantia de que toda interação/local measurement individual precisa usar exatamente o mesmo limite.

Eles são thresholds das métricas Web Vitals.

## Field Data

[DEFAULT] Field data representa experiência real dos usuários sob dispositivos, redes e comportamentos reais.

Quando disponível, use para responder:

```text
is this a real-user problem?
which pages/users are affected?
```

## Lab Data

[DEFAULT] Lab data é útil para:

```text
reproduce
debug
compare changes
detect regressions before release
```

[HARD RULE] Lab rápido não invalida field ruim.

[HARD RULE] Field ruim também não explica sozinho a causa.

## LCP

LCP representa quando o maior conteúdo relevante visível no viewport inicial é renderizado.

Quando LCP está ruim, investigue a cadeia:

```text
server/resource discovery
→ resource download
→ main-thread/render delay
→ LCP element paints
```

[HARD RULE] Não "otimize LCP" escondendo o elemento principal ou trocando markup apenas para manipular a métrica.

Melhore a experiência real.

## LCP Resource Discovery

[DEFAULT] O recurso LCP deve ser descoberto cedo quando possível.

Problemas comuns:

```text
hero image discovered only after JS
large CSS/JS blocks rendering
late data requirement
unnecessarily lazy-loaded above-the-fold image
```

[HARD RULE] Não lazy-load automaticamente o principal asset above the fold quando ele é candidato provável a LCP.

## Images

[DEFAULT] Defina dimensions/aspect behavior para evitar layout instability e preserve tamanho apropriado ao uso.

Considere:

```text
responsive source
correct dimensions
appropriate format
priority for critical image
lazy loading for offscreen images
```

[HARD RULE] Não entregue imagem enorme apenas para exibi-la pequena se isso é um custo relevante.

## INP

INP representa responsiveness das interações ao longo da visita.

Um INP ruim pode envolver:

```text
input delay
event handler work
render/update work
presentation delay
```

[HARD RULE] Não atribua INP ruim automaticamente a React rerenders.

Use browser/React profiling para localizar o custo.

## Long Tasks

[DEFAULT] Trabalho longo no main thread pode atrasar resposta a input.

Procure:

```text
large JS execution
heavy parsing
expensive synchronous calculation
third-party scripts
large render/layout work
```

Possíveis respostas dependem da causa:

```text
reduce work
split work
defer non-urgent work
move computation
remove third-party cost
```

## Avoid Blocking User Input

[HARD RULE] Não execute cálculo pesado síncrono no event handler se ele pode ser evitado/restructured.

Se o trabalho precisa acontecer, meça se:

```text
algorithm improvement
worker
transition/deferred UI
incremental processing
```

faz sentido.

Não escolha técnica antes de profiling.

## CLS

CLS mede mudanças inesperadas de layout.

Fontes comuns:

```text
images without reserved space
async content inserted above existing content
font/layout changes
ads/embeds without dimensions
late UI banners
```

[DEFAULT] Reserve espaço quando tamanho/layout pode ser conhecido antecipadamente.

## Loading Placeholders

[DEFAULT] Skeleton/fallback deve preservar dimensões aproximadas quando isso reduz layout shift e mantém contexto.

Não crie placeholder com tamanho radicalmente diferente do conteúdo final.

UI semantics pertencem a ui-states/loading.

## Dynamic Content

[HARD RULE] Não insira conteúdo acima da área atual de leitura/interação sem necessidade quando isso desloca a página inesperadamente.

Quando conteúdo novo precisa aparecer, escolha placement/comportamento previsível.

## Fonts

[SITUATIONAL] Font loading pode afetar paint e layout.

Avalie:

```text
font file size
number of variants
fallback metrics
loading strategy
```

[HARD RULE] Não carregue múltiplos weights/styles que a aplicação não usa.

Tooling/hosting exato depende do projeto.

## CSS and Layout Work

[DEFAULT] Layout/paint complexity só deve ser otimizada quando profiling mostra custo.

Evite mudanças de CSS micro-otimizadas sem evidência.

Quando layout thrashing ocorre em código imperativo, agrupe leituras/escritas quando possível e reavalie a necessidade da manipulação.

## Third-Party Impact

Third-party code pode afetar:

```text
network
main thread
layout
interaction
privacy/security
```

Se profiling identifica terceiro como custo, reduza/atrase/isole conforme requisitos.

Security boundary pertence a security/third-party-code.

## Responsive Performance

[DEFAULT] Avalie dispositivos mais lentos e viewport/mobile quando representam usuários reais.

Uma máquina desktop potente pode esconder:

```text
JS parse/execute cost
slow interaction
image transfer cost
layout work
```

## Accessibility and Performance

[HARD RULE] Não melhore métrica removendo:

```text
semantic content
focus indication
accessible labels
necessary status feedback
```

Performance e accessibility são requisitos simultâneos.

## Common Bug Patterns

Evite:

- perseguir score sem identificar causa;
- lazy-load do asset LCP crítico;
- image sem dimensões reservadas;
- conteúdo async empurrando UI existente;
- atribuir INP a React sem profiling;
- event handler com trabalho pesado evitável;
- carregar todas as font variants;
- remover feedback acessível para reduzir DOM;
- otimizar apenas desktop dev machine.

## Responsibility Boundaries

Esta referência é dona de:

- LCP/INP/CLS;
- field vs lab reasoning;
- browser rendering/main-thread performance;
- image/font/layout performance signals.

Outras responsabilidades:

- React render cost → `rendering-performance.md`;
- bundle/code loading → `bundle-loading.md`;
- requests/cache → `data-network.md`;
- profiling workflow → `measurement-profiling.md`;
- accessibility → accessibility references.
