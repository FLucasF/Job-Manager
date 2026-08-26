# React Design-System Components with TypeScript

Referência para APIs tipadas de componentes reutilizáveis de design system.

## Contents

- Component API strategy
- Variants and sizes
- Native element contracts
- Renderable regions
- Styling boundary
- Accessibility boundary
- Responsibility boundaries

## Component API Strategy

[DEFAULT] Modele a API em termos de decisões de design/uso que os consumidores realmente precisam.

```tsx
interface BadgeProps {
  variant: 'default' | 'success' | 'warning' | 'error'
  size?: 'sm' | 'md'
  icon?: React.ReactNode
  children: React.ReactNode
}
```

[HARD RULE] Não exponha detalhes internos de styling como API pública sem necessidade.

## Variants

Use unions quando o conjunto de variantes é conhecido:

```ts
variant: 'default' | 'success' | 'warning' | 'error'
```

[DEFAULT] Uma variant deve representar uma diferença semântica/visual suportada pelo design system.

Não crie variants pontuais para contornar uma tela específica.

## Sizes

Use valores conhecidos quando o componente suporta uma escala discreta:

```ts
size?: 'sm' | 'md'
```

Forneça default somente quando existe uma escolha padrão real.

## Native Element Contracts

[DEFAULT] Se o design-system component encapsula um elemento HTML, preserve os atributos nativos adequados quando isso faz parte da API.

Consulte `props.md` para extensão de atributos e conflitos.

## Renderable Regions

Use `React.ReactNode` para conteúdo e ícones simples:

```ts
icon?: React.ReactNode
children: React.ReactNode
```

Quando o consumidor precisa de dados internos para renderizar, considere render function.

Consulte `render-props-slots.md`.

## Styling Boundary

[HARD RULE] O contrato TypeScript deve expressar a API do componente; a implementação de classes/Tailwind pertence às referências de styling.

Não deixe nomes de utility classes vazarem como tipos públicos da API sem motivo.

## Accessibility Boundary

[HARD RULE] Não atribua roles/ARIA apenas porque um componente pertence ao design system.

Semântica depende da responsabilidade real do componente e deve seguir as referências de accessibility.

## Responsibility Boundaries

Esta referência cobre:

- typed design-system API;
- variants;
- sizes;
- renderable regions.

Outras responsabilidades:

- general props/native wrappers → `props.md`;
- children → `children.md`;
- render functions → `render-props-slots.md`;
- Tailwind styling → Tailwind references;
- semantics/ARIA → accessibility references.
