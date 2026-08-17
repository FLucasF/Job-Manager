# TypeScript Type Safety

Referência de decisões e armadilhas para preservar segurança de tipos no TypeScript.

## Contents

- Type safety strategy
- `any`
- Object modeling
- Dynamic property access
- Enums
- `unique symbol`
- Type assertions
- Responsibility boundaries

## Type Safety Strategy

[HARD RULE] Quando houver um erro de tipos, corrija a modelagem ou o fluxo de tipos antes de contornar o compilador.

[DEFAULT] Prefira tipos que representem corretamente os valores possíveis da aplicação.

Não reduza segurança de tipos apenas para fazer o código compilar.

## Implicit `any`

[HARD RULE] Evite parâmetros ou valores com `any` implícito.

Quando o TypeScript não conseguir inferir um tipo com segurança, declare o tipo correto explicitamente.

```ts
function process(value: string) {
  return value;
}
```

Não desabilite verificações ou introduza `any` apenas para eliminar o erro.

## Explicit `any`

[HARD RULE] `any` explícito desativa parte relevante da verificação de tipos.

Use somente quando existir uma justificativa técnica concreta.

Antes de usar `any`, determine se o valor pode ser representado com:

- tipo conhecido;
- union;
- generic;
- `unknown` seguido de narrowing;
- tipo já existente no projeto.

## Object Modeling

[DEFAULT] Represente estruturas conhecidas com `type` ou `interface`.

```ts
interface User {
  id: number;
  name: string;
  email: string;
}
```

[HARD RULE] Não duplique um contrato já existente sem necessidade.

Use a representação adotada pelo projeto quando houver uma equivalente.

## Dynamic Property Access

Use `keyof` quando uma operação deve aceitar somente propriedades existentes.

```ts
function getProperty<T, K extends keyof T>(
  object: T,
  key: K,
): T[K] {
  return object[key];
}
```

[HARD RULE] Evite strings arbitrárias para acessar objetos quando o tipo conhece as chaves válidas.

Preserve a relação entre chave e valor usando `keyof`, indexed access ou outra modelagem equivalente.

## Enums

[SITUATIONAL] Use enums quando o projeto adota essa representação para um conjunto conhecido de valores.

```ts
enum VacancyStatus {
  Open,
  Closed,
}
```

[DEFAULT] Antes de criar um enum, verifique se já existe uma representação equivalente no projeto.

Não introduza uma segunda forma para o mesmo domínio sem necessidade.

## `unique symbol`

[SITUATIONAL] Use `unique symbol` somente quando a implementação realmente depende de identidade única no sistema de tipos.

Não utilize em código comum apenas porque a API existe.

## Type Assertions

[HARD RULE] Não use assertions apenas para obrigar o TypeScript a aceitar um valor.

Evite sem garantia real:

```ts
const user = value as User;
```

Antes de uma assertion:

1. verifique se o tipo pode ser inferido;
2. verifique se narrowing resolve;
3. valide dados externos quando necessário;
4. use assertion somente quando existe uma garantia concreta.

## Responsibility Boundaries

Esta referência cobre:

- `any`;
- modelagem básica de objetos;
- `keyof`;
- indexed access;
- enums;
- `unique symbol`;
- assertions.

Outras responsabilidades:

- generics e inferência → `inference-generics.md`;
- `null` e `undefined` → `nullability.md`;
- imports/módulos → `modules-imports.md`;
- compiler options → `compiler-config.md`;
- tipagem específica de React → `references/react-typescript/`.
