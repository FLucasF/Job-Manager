# Bundle Loading — React and Vite mechanisms

Stack mechanisms for the `performance/bundle-loading.md` concern reference. The rule lives in the
concern reference; this file states how React and Vite expresses it.

## `React.lazy`

Use `lazy` quando um component React deve ter seu código carregado apenas quando renderizado.

```tsx
const MarkdownPreview = lazy(
  () => import('./MarkdownPreview'),
)
```

[HARD RULE] Declare lazy components no module scope, não dentro de outro component.

Criar `lazy()` durante render pode resetar state e recriar component identity.

## Vite Dynamic Imports

[DEFAULT] Em Vite, preserve dynamic imports que possam ser analisados/bundled corretamente.

Não construa import path arbitrário vindo de runtime/user input.

Além de fragilidade de build, remote/plugin imports podem criar security boundary.

## Vite Async Chunks

Vite já aplica otimizações para async chunk loading e CSS associado a chunks.

[HARD RULE] Não adicione preload manual para todo chunk antes de medir benefício.

Bundler defaults devem ser preservados até existir motivo concreto para override.
