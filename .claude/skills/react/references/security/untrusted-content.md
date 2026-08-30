# Untrusted Content — React mechanisms

Stack mechanisms for the `security/untrusted-content.md` concern reference. The rule lives in the
concern reference; this file states how React expresses it.

## Prefer React Text Rendering

[DEFAULT] Para conteúdo textual, preserve o rendering normal do React.

```tsx
<p>{comment.body}</p>
```

React trata esse valor como conteúdo textual em vez de interpretar a string como HTML.

[HARD RULE] Não converta texto em HTML apenas para preservar formatação simples que pode ser representada por componentes/estrutura segura.
