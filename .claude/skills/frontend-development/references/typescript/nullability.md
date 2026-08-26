# TypeScript Nullability

Referência de decisões e armadilhas para `null`, `undefined` e valores potencialmente ausentes.

## Contents

- Nullability strategy
- `undefined`
- `null`
- Narrowing
- Optional chaining
- Arithmetic and operations
- Non-null assertions
- Responsibility boundaries

## Nullability Strategy

[HARD RULE] Represente ausência explicitamente quando `null` ou `undefined` fazem parte dos valores possíveis.

Antes de usar um valor potencialmente ausente:

1. reconheça a possibilidade no tipo;
2. faça narrowing;
3. trate o caso ausente;
4. só então use o valor.

Não contorne nullability apenas para fazer o código compilar.

## `undefined`

[HARD RULE] Não utilize um valor `undefined` como se ele fosse válido.

```ts
function printName(name: string | undefined) {
  if (name !== undefined) {
    console.log(name);
  }
}
```

A ausência deve ser tratada de acordo com o contrato da operação.

## `null`

[HARD RULE] Se `null` faz parte do domínio esperado, represente-o no tipo.

```ts
function getName(): string | null {
  return null;
}
```

Não retorne `null` de uma função cujo contrato declara apenas `string`.

## Narrowing

[DEFAULT] Faça narrowing antes de acessar ou operar sobre valores potencialmente ausentes.

```ts
function getLength(value: string | undefined): number {
  if (value === undefined) {
    return 0;
  }

  return value.length;
}
```

Depois da verificação, o TypeScript pode tratar `value` como `string`.

## Optional Chaining

Use `?.` quando o acesso deve acontecer somente se a cadeia existir.

```ts
const name = user?.profile?.name;
```

[HARD RULE] O resultado ainda pode ser `undefined`.

Não use optional chaining para esconder uma modelagem incorreta ou evitar uma decisão necessária sobre ausência.

## Narrowing after Optional Access

Verificações podem restringir valores acessados com optional chaining.

```ts
if (typeof user?.age === "number") {
  console.log(user.age);
}
```

Use a verificação que corresponde ao tipo realmente esperado.

## Arithmetic and Other Operations

[HARD RULE] Não use valores potencialmente `undefined` diretamente em operações que exigem um valor concreto.

```ts
function double(value: number | undefined): number {
  if (value === undefined) {
    return 0;
  }

  return value * 2;
}
```

Trate a ausência antes da operação.

## Non-Null Assertions

[HARD RULE] Evite `!` quando a ausência é realmente possível.

```ts
const name = user!.name;
```

Use non-null assertion somente quando existe garantia concreta de que o valor está presente.

[DEFAULT] Quando a ausência é uma possibilidade legítima de runtime, prefira narrowing explícito.

## Responsibility Boundaries

Esta referência cobre:

- `null`;
- `undefined`;
- narrowing de ausência;
- optional chaining;
- non-null assertions.

Outras responsabilidades:

- assertions gerais → `type-safety.md`;
- optional props específicas de React → referências `react-typescript/`;
- compiler strictness → `compiler-config.md`.
