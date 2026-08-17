# TypeScript Compiler Configuration

Referência de decisões e armadilhas para `tsconfig.json` e opções globais do compilador.

## Contents

- Configuration strategy
- Strictness
- `target`
- `lib`
- Module configuration
- Type definitions
- Compiler plugins
- JSX compiler boundary
- Validation after changes
- Responsibility boundaries

## Configuration Strategy

[HARD RULE] Trate mudanças no `tsconfig.json` como alterações globais.

Antes de alterar configuração:

1. identifique o problema real;
2. inspecione a configuração atual;
3. avalie impacto no projeto inteiro;
4. prefira corrigir código local antes de alterar regra global.

[HARD RULE] Não relaxe o compilador apenas para fazer a implementação compilar.

## Strictness

[DEFAULT] Preserve as verificações de segurança já adotadas pelo projeto.

Quando `noImplicitAny` ou outras opções estritas estiverem habilitadas, corrija o código antes de enfraquecer a configuração.

```ts
function process(value: string) {
  return value;
}
```

Não desabilite strictness para eliminar erros isolados.

## `target`

`target` controla a versão de JavaScript emitida.

Uma mudança pode afetar:

- sintaxe gerada;
- compatibilidade de runtime;
- bundler;
- testes;
- ambiente de execução.

[HARD RULE] Não altere `target` sem entender o runtime suportado pelo projeto.

## `lib`

`lib` controla quais APIs o TypeScript considera disponíveis.

Quando uma API não é reconhecida:

1. verifique a versão do TypeScript;
2. verifique `target`;
3. verifique `lib`;
4. confirme suporte real no runtime;
5. só então altere a configuração.

[HARD RULE] Não adicione `lib` apenas para silenciar o compilador quando o runtime não suporta a API.

## Module Configuration

Opções de módulo podem afetar:

- `import`/`export`;
- ESM/CommonJS;
- module resolution;
- bundler;
- runtime.

[HARD RULE] Não altere opções de módulo isoladamente sem avaliar o restante da aplicação.

Problemas de imports e resolução também devem consultar `modules-imports.md`.

## Type Definitions

[SITUATIONAL] Algumas APIs exigem declaration packages como `@types/*`.

Antes de instalar, verifique se a dependência já fornece seus próprios tipos.

Não altere `types`, `lib` ou outras opções globais apenas para contornar um erro de import mal diagnosticado.

## Compiler Plugins

[SITUATIONAL] Adicione plugin do TypeScript somente quando ele resolve uma necessidade concreta.

Antes:

1. confirme a responsabilidade;
2. verifique se já existe ferramenta equivalente;
3. avalie impacto em IDE, build e manutenção.

Não adicione plugin apenas porque ele está disponível.

## JSX Compiler Boundary

[HARD RULE] Regras de tipagem de componentes React não pertencem a esta referência.

Esta referência só deve tratar JSX quando a tarefa envolver **configuração do compilador**, por exemplo uma opção `jsx` no `tsconfig`.

Para props, children, events, refs, components e demais decisões React + TypeScript, use `references/react-typescript/`.

## Validation after Changes

Após qualquer mudança de compiler configuration:

1. execute typecheck;
2. execute testes relacionados;
3. execute build quando fizer parte da validação do projeto;
4. verifique novos erros em outros arquivos;
5. confirme que a mudança global era necessária.

## Responsibility Boundaries

Esta referência cobre:

- `tsconfig.json`;
- strictness;
- `target`;
- `lib`;
- module compiler options;
- compiler plugins;
- JSX apenas como compiler configuration.

Outras responsabilidades:

- imports/module resolution → `modules-imports.md`;
- type modeling → `type-safety.md`;
- React/TSX typing → `references/react-typescript/`.
