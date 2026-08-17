# Tailwind Tooling and Integrations

Referência de decisões para integração do Tailwind com build tools, editor tooling e bibliotecas complementares.

## Contents

- Tooling strategy
- Vite, PostCSS and CLI
- Prettier and IntelliSense
- Headless UI
- Heroicons
- `@tailwindcss/forms`
- Plugin registration
- Responsibility boundaries

## Tooling Strategy

[HARD RULE] Não instale todas as integrações por padrão.

Escolha a ferramenta pela responsabilidade:

```text
@tailwindcss/vite       → projetos Vite
@tailwindcss/postcss    → pipelines PostCSS
@tailwindcss/cli        → compilação direta
prettier-plugin-tailwindcss → ordenação de classes
Tailwind CSS IntelliSense   → editor support
@headlessui/react       → componentes headless acessíveis
@heroicons/react        → ícones React
@tailwindcss/forms      → base de styling para form controls
```

[DEFAULT] Use um caminho principal de build e adicione ferramentas complementares somente quando resolvem uma necessidade real.

## Vite Integration

[DEFAULT] Em projetos Vite, use `@tailwindcss/vite`.

```ts
import { defineConfig } from 'vite'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [tailwindcss()],
})
```

CSS principal:

```css
@import "tailwindcss";
```

[HARD RULE] Não adicione PostCSS apenas por hábito quando a integração de Vite já atende ao pipeline.

## PostCSS Integration

[SITUATIONAL] Use `@tailwindcss/postcss` quando o framework ou pipeline depende de PostCSS.

O CSS principal continua:

```css
@import "tailwindcss";
```

[HARD RULE] Não mantenha Vite plugin e PostCSS como caminhos paralelos sem necessidade concreta.

## Tailwind CLI

[SITUATIONAL] Use `@tailwindcss/cli` quando Tailwind precisa ser compilado diretamente, sem integração de framework.

```sh
npx @tailwindcss/cli -i ./src/input.css -o ./src/output.css --watch
```

[SITUATIONAL] O standalone CLI é útil quando o ambiente não deve depender de Node.js.

[DEFAULT] Não adicione uma etapa CLI redundante a um projeto que já possui integração adequada com seu build tool.

## Prettier Plugin

[SITUATIONAL] Use `prettier-plugin-tailwindcss` quando o projeto já usa Prettier e deseja ordenar classes automaticamente.

[DEFAULT] Quando o formatter assume essa responsabilidade, não mantenha uma convenção paralela de ordenação manual.

[HARD RULE] Ordenação de classes não valida comportamento, acessibilidade ou correção visual.

## Tailwind CSS IntelliSense

[SITUATIONAL] Use Tailwind CSS IntelliSense para feedback de editor sobre:

- utilities;
- variants;
- directives;
- theme variables;
- arbitrary values.

[HARD RULE] Editor tooling não substitui typecheck, lint, testes ou revisão visual.

## Headless UI with React

[SITUATIONAL] Use `@headlessui/react` quando o projeto precisa de componentes com comportamento acessível sem styling visual pronto.

```tsx
import { Button } from '@headlessui/react'

export function SaveButton() {
  return (
    <Button className="rounded px-4 py-2 data-hover:bg-sky-500">
      Save changes
    </Button>
  )
}
```

Headless UI pode expor estado por `data-*`, consumido diretamente pelas variants do Tailwind.

[DEFAULT] Observe o estado exposto pelo componente em vez de duplicá-lo somente para styling.

[HARD RULE] Não adicione Headless UI apenas porque Tailwind está presente.

Uso de `data-*` pertence a `responsive-variants.md`; requisitos de acessibilidade pertencem às referências de accessibility.

## Heroicons with React

[SITUATIONAL] Use `@heroicons/react` quando Heroicons é a biblioteca de ícones adotada pelo projeto.

Use imports por tamanho e estilo:

```tsx
import { MagnifyingGlassIcon } from '@heroicons/react/24/outline'
```

Paths relevantes incluem:

```text
16/solid
20/solid
24/solid
24/outline
```

[HARD RULE] Evite imports legados:

```text
@heroicons/react/solid
@heroicons/react/outline
```

[DEFAULT] Não introduza outra biblioteca de ícones quando o projeto já possui uma solução consistente sem necessidade concreta.

## `@tailwindcss/forms`

[SITUATIONAL] Use `@tailwindcss/forms` quando o projeto deseja uma base utility-friendly para form controls nativos.

Registre no CSS:

```css
@import "tailwindcss";
@plugin "@tailwindcss/forms";
```

[HARD RULE] O plugin é apenas uma camada de styling. Ele não substitui:

- componentes;
- validação;
- estado de formulário;
- semântica;
- accessibility.

## Plugin Registration

[HARD RULE] Para código atual, prefira registro CSS-first quando a integração suporta esse caminho.

```css
@plugin "@tailwindcss/forms";
```

Não introduza `tailwind.config.js` apenas para registrar plugins que podem ser declarados no CSS.

Use configuração JavaScript somente quando uma integração concreta exigir compatibilidade ou comportamento não disponível na configuração CSS-first.

## Dependency Discipline

Antes de adicionar uma integração, identifique a responsabilidade:

```text
build integration?
formatter?
editor tooling?
accessible component behavior?
icons?
form control baseline?
```

[HARD RULE] Se a responsabilidade já está atendida, não adicione outra ferramenta equivalente.

## Responsibility Boundaries

Esta referência cobre:

- Vite, PostCSS e CLI;
- Prettier e editor tooling;
- Headless UI;
- Heroicons;
- `@tailwindcss/forms`;
- plugin registration relacionado.

Outras responsabilidades:

- configuração CSS-first, `@theme`, `@utility`, `@custom-variant` → `theme-customization.md`;
- `data-*`, state e responsive variants → `responsive-variants.md`;
- forms → referências de forms;
- semântica e acessibilidade → accessibility references;
- utilities específicas → referência Tailwind do domínio correspondente.
