# TypeScript Review Checklist

Checklist operacional para revisar código TypeScript sem carregar todas as referências detalhadas.

[DEFAULT] Use este arquivo primeiro em revisão de TypeScript.

[HARD RULE] Consulte uma referência detalhada somente quando um item exigir investigação.

## Type Safety

- [ ] Não existe `any` implícito?
- [ ] `any` explícito possui justificativa concreta?
- [ ] Tipos existentes foram reutilizados antes de criar novos contratos?
- [ ] Object shapes representam os valores reais esperados?
- [ ] Acesso dinâmico preserva relação entre chave e valor?
- [ ] Assertions possuem garantia concreta?
- [ ] Erros de tipo foram corrigidos pela modelagem em vez de contornados?

## Inference and Generics

- [ ] Annotations não repetem inferência óbvia sem benefício?
- [ ] Contextual typing é aproveitado quando já fornece tipos corretos?
- [ ] Generics preservam uma relação real entre tipos?
- [ ] Constraints exigem somente o contrato necessário?
- [ ] Múltiplos generic parameters realmente adicionam segurança/reutilização?
- [ ] `any` não foi usado onde um generic deveria preservar tipos?
- [ ] Generics React-specific foram revisados na referência skill `react` (generic-components.md)?

## Nullability

- [ ] `null` e `undefined` fazem parte do tipo quando são possibilidades reais?
- [ ] Valores ausentes são tratados antes do uso?
- [ ] Narrowing ocorre antes de operações que exigem valor concreto?
- [ ] Optional chaining não está escondendo problema de modelagem?
- [ ] O resultado potencialmente `undefined` de `?.` continua sendo tratado?
- [ ] Non-null assertion (`!`) possui garantia concreta?
- [ ] Assertions não estão substituindo tratamento legítimo de ausência?

## Modules and Imports

- [ ] Imports/exports seguem a convenção existente?
- [ ] Aliases e module resolution existentes foram preservados?
- [ ] `import type` é usado quando apropriado?
- [ ] `.d.ts` existe somente quando declaration file é realmente necessário?
- [ ] `@types/*` não duplica tipos já fornecidos pela biblioteca?
- [ ] Workarounds de import não escondem problema de configuração?
- [ ] ESM/CommonJS não foi alterado localmente sem avaliar impacto?
- [ ] `package.json`/entry points não foram modificados para contornar erro isolado?

## Compiler Configuration

- [ ] Alterações em `tsconfig.json` são realmente necessárias?
- [ ] Strictness não foi reduzida para eliminar erros?
- [ ] `target` corresponde ao runtime suportado?
- [ ] `lib` não declara APIs ausentes do runtime real?
- [ ] Module options permanecem coerentes com bundler/runtime?
- [ ] Compiler plugins possuem responsabilidade concreta?
- [ ] Mudança global não está sendo usada para corrigir problema local?
- [ ] Typecheck/testes/build relevantes foram executados após mudança?

## React Boundary

- [ ] Regras específicas de React não foram duplicadas aqui, permanecendo na skill `react`?
- [ ] Props, children, events, refs, hooks e componentes genéricos usam skill `react`?
- [ ] JSX só aparece aqui quando a questão é compiler configuration?
- [ ] Não existe um `react-jsx.md` duplicando o grupo React + TypeScript?

## Escalation

Carregue somente a referência relacionada ao item encontrado:

```text
any / assertions / object modeling / keyof
→ type-safety.md

inference / contextual typing / generics
→ inference-generics.md

null / undefined / optional chaining
→ nullability.md

imports / exports / .d.ts / module resolution
→ modules-imports.md

tsconfig / target / lib / strictness / compiler plugins
→ compiler-config.md

React-specific typing
→ skill react
```

[HARD RULE] Não carregue todos os arquivos TypeScript por padrão.
