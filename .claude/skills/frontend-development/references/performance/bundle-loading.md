# Frontend Bundle and Code Loading Performance

Referência para reduzir custo de código inicial e escolher boundaries de lazy/code splitting.

## Contents

- Measure bundle impact
- Initial vs deferred code
- Dynamic import
- `React.lazy`
- Suspense boundary
- Route-level splitting
- Vite behavior
- Chunk strategy
- Dependency cost
- Preload/prefetch
- Load failures
- Responsibility boundaries

## Measure Before Splitting

[HARD RULE] Não aplique code splitting automaticamente a cada component/route.

Primeiro confirme um problema relacionado a:

```text
initial JavaScript size
download time
parse/execute time
large optional dependency
rarely-used feature
```

Consulte `measurement-profiling.md`.

## Initial vs Deferred Code

Pergunte:

```text
Esse código é necessário para a primeira experiência útil?
```

Se sim:

```text
initial path
```

Se não e possuir custo relevante:

```text
candidate for deferred loading
```

[HARD RULE] Adiar código também possui custo: request, fallback e possível loading waterfall.

## Dynamic `import()`

[SITUATIONAL] Use dynamic import para transformar código em async boundary quando o bundler suporta e o benefício é concreto.

```ts
const module = await import('./feature')
```

Não transforme imports estáticos pequenos em dynamic imports apenas para aumentar número de chunks.

## `React.lazy`

Use `lazy` quando um component React deve ter seu código carregado apenas quando renderizado.

```tsx
const MarkdownPreview = lazy(
  () => import('./MarkdownPreview'),
)
```

[HARD RULE] Declare lazy components no module scope, não dentro de outro component.

Criar `lazy()` durante render pode resetar state e recriar component identity.

## Suspense for Lazy Code

Um lazy component precisa de um Suspense boundary apropriado.

```tsx
<Suspense fallback={<Loading />}>
  <LazyFeature />
</Suspense>
```

[DEFAULT] Coloque o boundary no menor nível que produz uma experiência coerente de loading.

[HARD RULE] Não envolva a aplicação inteira num fallback global se apenas uma área opcional está carregando e o restante pode continuar utilizável.

UI loading semantics pertencem a ui-states/loading.

## Suspense Is Not Generic Effect Fetch Loading

[HARD RULE] Não assuma que `<Suspense>` detecta qualquer request feita em `useEffect`.

Use Suspense somente para fontes/flows que realmente suspendem.

## Route-Level Code Splitting

[SITUATIONAL] Routes são bons candidates quando representam áreas grandes e independentes.

Se React Router já oferece uma estratégia de route lazy loading no mode usado, preserve essa estratégia.

[HARD RULE] Não crie uma segunda camada de lazy loading conflitante com o router/framework.

## Vite Dynamic Imports

[DEFAULT] Em Vite, preserve dynamic imports que possam ser analisados/bundled corretamente.

Não construa import path arbitrário vindo de runtime/user input.

Além de fragilidade de build, remote/plugin imports podem criar security boundary.

## Vite Async Chunks

Vite já aplica otimizações para async chunk loading e CSS associado a chunks.

[HARD RULE] Não adicione preload manual para todo chunk antes de medir benefício.

Bundler defaults devem ser preservados até existir motivo concreto para override.

## Chunk Count

Mais chunks não significa automaticamente melhor performance.

Trade-off:

```text
large initial chunk
vs
many requests / scheduling / cache relationships
```

[DEFAULT] Prefira boundaries alinhados a features/routes/dependencies reais.

## Custom Chunking

[SITUATIONAL] Customize chunk strategy somente quando bundle analysis mostra benefício concreto.

[HARD RULE] Não crie `manualChunks`/custom bundler splitting baseado em intuição.

Mudanças precisam ser verificadas no production build.

## Large Dependencies

Quando bundle analysis identifica uma dependency pesada:

1. confirme se ela é realmente usada;
2. verifique se import style permite tree shaking;
3. avalie API menor já disponível no projeto;
4. considere lazy loading se uso é opcional;
5. remova dependency se não necessária.

[HARD RULE] Não reimplemente biblioteca complexa apenas para economizar bundle sem considerar correctness/manutenção.

## Tree Shaking

[DEFAULT] Prefira imports compatíveis com a forma recomendada pela library/bundler.

Não suponha que:

```text
named import
```

sempre garante bundle mínimo; verifique output quando tamanho importa.

## JSON and Large Static Data

[SITUATIONAL] Dados grandes importados estaticamente podem aumentar bundle inicial.

Se não são necessários no first path, considere outro loading boundary.

Não mova dados para network apenas por estética; compare custo/ownership.

## Preload and Prefetch

[SITUATIONAL] Preloading pode ajudar quando há alta probabilidade de o recurso ser necessário em breve.

[HARD RULE] Não pre-carregue tudo.

Isso transforma lazy loading em eager loading e compete por bandwidth.

## Interaction-Driven Preload

[SITUATIONAL] Alguns fluxos podem antecipar carregamento a partir de intenção provável:

```text
hover/focus on navigation
known next step
idle opportunity
```

Use apenas quando tooling/framework suporta e a evidência justifica.

## Load Failures

Dynamic imports podem falhar após deploy/cache mismatch ou problema de network.

[DEFAULT] Mantenha uma estratégia coerente de error handling no boundary responsável.

Não implemente reload loop automático infinito.

## Cache Invalidation and Deploys

[SITUATIONAL] Assets content-hashed normalmente permitem caching eficiente.

Não codifique chunk filenames gerados diretamente na aplicação.

Deixe bundler/runtime resolver manifests/imports.

## Common Bug Patterns

Evite:

- lazy em todo component;
- `lazy()` dentro do render;
- Suspense global para feature pequena;
- manual chunking sem análise;
- preload de todo código deferred;
- importar library inteira para uma função;
- dynamic path arbitrário;
- duplicar route lazy mechanism;
- usar dev bundle como evidência final.

## Responsibility Boundaries

Esta referência é dona de:

- JavaScript/code loading;
- `lazy` + Suspense para code;
- bundle/chunk decisions;
- dependency loading cost.

Outras responsabilidades:

- route lazy APIs → react-router;
- loading UX → ui-states/loading;
- measurement → `measurement-profiling.md`;
- network data → `data-network.md`.
