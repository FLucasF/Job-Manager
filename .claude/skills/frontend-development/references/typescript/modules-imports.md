# TypeScript Modules and Imports

Referência de decisões para imports, exports, declarations e resolução de módulos.

## Contents

- Module strategy
- Project conventions
- Type-only imports
- Declaration files
- External typings
- Module resolution
- Package entry points
- ESM and CommonJS
- Responsibility boundaries

## Module Strategy

[HARD RULE] Preserve o padrão de módulos já adotado pelo projeto.

Use `import` e `export` de acordo com a configuração existente.

```ts
export function createUser() {
  // implementation
}
```

```ts
import { createUser } from "./create-user";
```

Não misture estratégias de módulo sem uma necessidade concreta.

## Existing Project Conventions

Antes de alterar imports, exports ou resolução:

1. inspecione o padrão atual;
2. verifique aliases existentes;
3. verifique `tsconfig.json`;
4. verifique `package.json` quando relevante;
5. preserve a estratégia de resolução já adotada.

[HARD RULE] Não crie um novo padrão de módulos apenas para resolver um problema local.

## Type-Only Imports

[DEFAULT] Quando um import existe apenas no sistema de tipos, use `import type` quando compatível com a configuração do projeto.

```ts
import type { User } from "./user";
```

Isso deixa explícito que o import não é necessário em runtime.

## Declaration Files

[SITUATIONAL] Use `.d.ts` quando for necessário descrever tipos para código que não possui tipagem própria.

Exemplos:

```text
index.d.ts
types.d.ts
global.d.ts
```

[HARD RULE] Não crie declaration file quando um tipo TypeScript normal no código da aplicação é suficiente.

## External Type Definitions

[SITUATIONAL] Algumas bibliotecas exigem `@types/*`.

Antes de adicionar um pacote:

1. verifique se a biblioteca já fornece seus próprios tipos;
2. confirme que o pacote de tipos corresponde à dependência usada pelo projeto;
3. não adicione typings apenas para silenciar um erro cuja causa é outra.

## Module Resolution

Problemas de import podem envolver:

- `package.json`;
- `node_modules`;
- aliases;
- `exports`;
- `module`;
- `moduleResolution`;
- `.d.ts`;
- dependências duplicadas.

[DEFAULT] Investigue a configuração existente antes de criar workaround.

## Package Entry Points

`package.json` pode definir como um pacote expõe seus arquivos através de campos como `main` ou `exports`.

[HARD RULE] Preserve a estratégia existente do pacote/projeto.

Não altere entry points para contornar um problema local sem avaliar os consumidores afetados.

## ESM and CommonJS

[SITUATIONAL] TypeScript pode operar com ESM ou CommonJS.

[HARD RULE] Não altere o formato de módulos isoladamente.

Mudanças podem afetar:

- imports;
- build;
- testes;
- bundler;
- runtime Node;
- dependências.

Mudanças de configuração relacionadas pertencem também a `compiler-config.md`.

## Responsibility Boundaries

Esta referência cobre:

- imports/exports;
- `import type`;
- `.d.ts`;
- external typings;
- module resolution;
- package entry points;
- ESM/CommonJS.

Outras responsabilidades:

- compiler module options → `compiler-config.md`;
- organização arquitetural de boundaries → architecture;
- imports específicos de React → referências `react-typescript/` quando houver regra React envolvida.
