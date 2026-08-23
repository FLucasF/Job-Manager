# Backlog Completo do Frontend — User Stories + Given/When/Then

Este documento consolida as funcionalidades identificadas a partir dos mockups do frontend, estruturadas em **User Stories** e critérios de aceitação no formato **Given / When / Then**.

## Padrão adotado

Cada story segue a estrutura:

```md
### STORY-XXX — Nome da funcionalidade

**Como** <ator>,
**quero** <ação/capacidade>,
**para** <benefício/objetivo>.

#### Cenário: <nome do cenário>

- **Dado (Given):** <estado inicial>.
1. **Quando (When):** <ação do usuário>.
2. **Então (Then):** <resultado observável esperado>.
```

Quando uma mesma capacidade possuir comportamentos distintos, a story pode conter múltiplos cenários.

---

# Épico 1 — Autenticação e sessão

## STORY-001 — Realizar login

**Como** visitante,
**quero** informar meu e-mail e minha senha,
**para** acessar a aplicação.

### Cenário: autenticação realizada com sucesso

- **Dado (Given):** que o usuário está na tela de login e possui credenciais válidas.
1. **Quando (When):** preencher e-mail e senha e selecionar `Entrar`.
2. **Então (Then):** o sistema deve autenticar o usuário e direcioná-lo para a tela de vagas disponíveis.

---

## STORY-002 — Validar formulário de login

**Como** visitante,
**quero** receber indicação quando os dados do login forem inválidos,
**para** corrigi-los antes da autenticação.

### Cenário: formulário inválido

- **Dado (Given):** que o usuário está na tela de login.
1. **Quando (When):** tentar entrar com e-mail ou senha obrigatório ausente ou com e-mail em formato inválido.
2. **Então (Then):** o sistema deve exibir os erros correspondentes e não deve realizar a requisição de autenticação.

---

## STORY-003 — Tratar credenciais inválidas

**Como** visitante,
**quero** ser informado quando minhas credenciais não forem aceitas,
**para** poder tentar novamente.

### Cenário: credenciais recusadas

- **Dado (Given):** que o usuário informou um e-mail e uma senha válidos quanto ao formato.
1. **Quando (When):** o servidor recusar a autenticação.
2. **Então (Then):** o sistema deve informar que as credenciais são inválidas sem revelar qual credencial está incorreta e permitir uma nova tentativa.

---

## STORY-004 — Exibir autenticação em andamento

**Como** visitante,
**quero** visualizar que minha autenticação está sendo processada,
**para** saber que minha solicitação foi recebida.

### Cenário: login em processamento

- **Dado (Given):** que o usuário preencheu corretamente o formulário.
1. **Quando (When):** selecionar `Entrar`.
2. **Então (Then):** o sistema deve indicar processamento e impedir novas submissões até a operação terminar.

---

## STORY-005 — Restaurar sessão autenticada

**Como** usuário autenticado,
**quero** permanecer autenticado enquanto minha sessão for válida,
**para** não precisar realizar login novamente.

### Cenário: sessão válida ao iniciar a aplicação

- **Dado (Given):** que existe uma sessão válida para o usuário.
1. **Quando (When):** o usuário recarregar ou abrir novamente a aplicação.
2. **Então (Then):** o sistema deve restaurar a sessão e permitir acesso ao conteúdo autenticado.

---

## STORY-006 — Proteger páginas privadas

**Como** sistema,
**quero** restringir funcionalidades privadas a usuários autenticados,
**para** impedir acesso não autorizado.

### Cenário: acesso sem autenticação

- **Dado (Given):** que não existe uma sessão autenticada válida.
1. **Quando (When):** o usuário tentar acessar uma rota protegida.
2. **Então (Then):** o sistema deve impedir o acesso e direcioná-lo para o login.

Rotas protegidas incluem:

- Vagas.
- Minhas Candidaturas.
- Criar Vaga.
- Perfil.

---

## STORY-007 — Tratar sessão expirada

**Como** usuário,
**quero** ser redirecionado para autenticação quando minha sessão expirar,
**para** continuar utilizando a aplicação com segurança.

### Cenário: sessão expirada durante o uso

- **Dado (Given):** que o usuário estava autenticado, mas sua sessão deixou de ser válida.
1. **Quando (When):** uma operação autenticada detectar a sessão expirada.
2. **Então (Then):** o sistema deve encerrar a sessão local e direcionar o usuário para o login.

---

## STORY-008 — Realizar logout

**Como** usuário autenticado,
**quero** sair da minha conta,
**para** encerrar minha sessão.

### Cenário: logout realizado com sucesso

- **Dado (Given):** que o usuário está autenticado.
1. **Quando (When):** selecionar `Sair`.
2. **Então (Then):** o sistema deve encerrar a sessão e direcioná-lo para o login.

---

# Épico 2 — Navegação principal

## STORY-009 — Exibir cabeçalho autenticado

**Como** usuário autenticado,
**quero** visualizar o cabeçalho principal,
**para** acessar informações e ações globais.

### Cenário: exibição do cabeçalho

- **Dado (Given):** que o usuário acessou uma área autenticada.
1. **Quando (When):** a página for exibida.
2. **Então (Then):** o sistema deve apresentar logo, identificação do usuário e ação `Sair`.

---

## STORY-010 — Navegar entre áreas principais

**Como** usuário,
**quero** navegar entre as áreas da aplicação,
**para** acessar diferentes funcionalidades.

### Cenário: navegação principal

- **Dado (Given):** que o usuário está autenticado.
1. **Quando (When):** selecionar `Vagas`, `Criar Vaga` ou `Perfil`.
2. **Então (Then):** o sistema deve exibir a área correspondente.

---

## STORY-011 — Indicar área selecionada

**Como** usuário,
**quero** visualizar qual seção está ativa,
**para** compreender minha localização na aplicação.

### Cenário: destaque da rota atual

- **Dado (Given):** que o usuário está em uma das áreas principais.
1. **Quando (When):** a navegação for renderizada.
2. **Então (Then):** o item correspondente à rota atual deve possuir indicação visual de seleção.

---

## STORY-012 — Exibir usuário autenticado

**Como** usuário,
**quero** visualizar minha identificação,
**para** saber qual conta está utilizando a aplicação.

### Cenário: identificação no cabeçalho

- **Dado (Given):** que existe uma sessão autenticada.
1. **Quando (When):** o cabeçalho for carregado.
2. **Então (Then):** o sistema deve apresentar a identificação correspondente ao usuário da sessão.

---

# Épico 3 — Vagas disponíveis

## STORY-013 — Consultar vagas disponíveis

**Como** usuário,
**quero** visualizar as vagas disponíveis,
**para** encontrar oportunidades de trabalho.

### Cenário: carregamento inicial das vagas

- **Dado (Given):** que o usuário está autenticado e acessou `Vagas`.
1. **Quando (When):** a página de vagas for carregada.
2. **Então (Then):** o sistema deve consultar e apresentar as vagas disponíveis.

---

## STORY-014 — Visualizar resumo da vaga

**Como** usuário,
**quero** visualizar um resumo de cada vaga,
**para** avaliar rapidamente as oportunidades.

### Cenário: exibição dos cards de vaga

- **Dado (Given):** que existem vagas disponíveis.
1. **Quando (When):** a lista for exibida.
2. **Então (Then):** cada card deve apresentar as informações resumidas previstas para a vaga e sua ação de candidatura.

---

## STORY-015 — Formatar informações das vagas

**Como** usuário,
**quero** visualizar datas, valores e informações de maneira padronizada,
**para** compreender os dados das vagas.

### Cenário: formatação de dados

- **Dado (Given):** que uma vaga possui informações como remuneração, data e localização.
1. **Quando (When):** o card da vaga for apresentado.
2. **Então (Then):** os dados devem ser formatados conforme o padrão definido pela aplicação.

---

## STORY-016 — Pesquisar vagas

**Como** usuário,
**quero** pesquisar vagas,
**para** encontrar oportunidades específicas.

### Cenário: pesquisa de vagas

- **Dado (Given):** que o usuário está visualizando as vagas disponíveis.
1. **Quando (When):** informar um termo no campo de pesquisa.
2. **Então (Then):** o sistema deve apresentar as vagas correspondentes ao critério informado.

---

## STORY-017 — Abrir filtros

**Como** usuário,
**quero** acessar os filtros de vagas,
**para** refinar minha pesquisa.

### Cenário: abertura dos filtros

- **Dado (Given):** que o usuário está na página de vagas.
1. **Quando (When):** selecionar `Filtrar`.
2. **Então (Then):** o sistema deve apresentar os controles de filtragem definidos para a aplicação.

> **Dependência de requisito:** o mockup atual não define quais filtros existem nem a interface utilizada.

---

## STORY-018 — Aplicar filtros

**Como** usuário,
**quero** aplicar critérios de filtragem,
**para** visualizar vagas mais relevantes.

### Cenário: aplicação dos filtros

- **Dado (Given):** que os controles de filtragem estão disponíveis.
1. **Quando (When):** o usuário selecionar filtros e aplicá-los.
2. **Então (Then):** a listagem deve apresentar somente vagas compatíveis com os filtros escolhidos.

---

## STORY-019 — Visualizar filtros ativos

**Como** usuário,
**quero** visualizar os filtros atualmente aplicados,
**para** compreender os critérios da listagem.

### Cenário: exibição dos filtros ativos

- **Dado (Given):** que pelo menos um filtro foi aplicado.
1. **Quando (When):** os resultados forem apresentados.
2. **Então (Then):** os filtros ativos devem permanecer visíveis na interface.

---

## STORY-020 — Remover filtro ativo

**Como** usuário,
**quero** remover individualmente um filtro,
**para** ampliar os resultados.

### Cenário: remoção de filtro

- **Dado (Given):** que existe um filtro ativo.
1. **Quando (When):** o usuário remover esse filtro.
2. **Então (Then):** o sistema deve atualizar a consulta sem o critério removido.

---

## STORY-021 — Combinar busca e filtros

**Como** usuário,
**quero** utilizar pesquisa textual e filtros simultaneamente,
**para** refinar meus resultados.

### Cenário: pesquisa combinada com filtros

- **Dado (Given):** que existe um termo de pesquisa e pelo menos um filtro selecionado.
1. **Quando (When):** a consulta for realizada.
2. **Então (Then):** o sistema deve considerar simultaneamente a pesquisa e os filtros.

---

## STORY-022 — Exibir ausência de resultados

**Como** usuário,
**quero** ser informado quando nenhuma vaga for encontrada,
**para** compreender o resultado da pesquisa.

### Cenário: nenhuma vaga encontrada

- **Dado (Given):** que a consulta foi concluída sem encontrar vagas.
1. **Quando (When):** o resultado for apresentado.
2. **Então (Then):** o sistema deve exibir um estado vazio em vez de uma área sem conteúdo.

---

## STORY-023 — Exibir carregamento de vagas

**Como** usuário,
**quero** perceber quando as vagas estão sendo carregadas,
**para** compreender que a consulta está em andamento.

### Cenário: consulta em andamento

- **Dado (Given):** que uma consulta de vagas foi iniciada.
1. **Quando (When):** a resposta ainda não estiver disponível.
2. **Então (Then):** o sistema deve apresentar um estado de carregamento.

---

## STORY-024 — Tratar erro ao carregar vagas

**Como** usuário,
**quero** ser informado quando as vagas não puderem ser carregadas,
**para** poder tentar novamente.

### Cenário: falha na consulta

- **Dado (Given):** que ocorreu uma falha ao consultar as vagas.
1. **Quando (When):** a consulta terminar com erro.
2. **Então (Then):** o sistema deve apresentar um estado de erro distinto do estado vazio.

---

# Épico 4 — Candidatura

## STORY-025 — Candidatar-se a uma vaga

**Como** usuário,
**quero** candidatar-me a uma vaga,
**para** demonstrar interesse na oportunidade.

### Cenário: candidatura realizada

- **Dado (Given):** que o usuário está visualizando uma vaga disponível à qual ainda não se candidatou.
1. **Quando (When):** selecionar `Candidatar`.
2. **Então (Then):** o sistema deve registrar a candidatura para a vaga correspondente.

---

## STORY-026 — Confirmar candidatura

**Como** usuário,
**quero** receber confirmação da candidatura,
**para** saber que ela foi registrada.

### Cenário: confirmação da candidatura

- **Dado (Given):** que uma solicitação de candidatura foi concluída com sucesso.
1. **Quando (When):** o frontend receber a confirmação.
2. **Então (Then):** deve apresentar feedback de sucesso e atualizar o estado da vaga.

---

## STORY-027 — Tratar erro na candidatura

**Como** usuário,
**quero** ser informado quando a candidatura falhar,
**para** poder tentar novamente.

### Cenário: falha na candidatura

- **Dado (Given):** que o usuário solicitou uma candidatura.
1. **Quando (When):** a operação falhar.
2. **Então (Then):** o sistema deve informar a falha e não deve considerar a vaga como candidatada.

---

## STORY-028 — Identificar candidatura existente

**Como** usuário,
**quero** saber que já me candidatei a uma vaga,
**para** evitar duplicidade.

### Cenário: vaga já candidatada

- **Dado (Given):** que o usuário já possui candidatura para determinada vaga.
1. **Quando (When):** essa vaga for apresentada.
2. **Então (Then):** o sistema deve indicar a candidatura existente e impedir uma nova candidatura duplicada.

---

# Épico 5 — Minhas candidaturas

## STORY-029 — Acessar minhas candidaturas

**Como** usuário,
**quero** acessar minhas candidaturas,
**para** acompanhar oportunidades às quais me candidatei.

### Cenário: acesso às candidaturas

- **Dado (Given):** que o usuário está na página de vagas disponíveis.
1. **Quando (When):** selecionar `Minhas Candidaturas`.
2. **Então (Then):** o sistema deve apresentar a área de candidaturas do usuário.

---

## STORY-030 — Consultar minhas candidaturas

**Como** usuário,
**quero** visualizar minhas candidaturas,
**para** acompanhar meu histórico.

### Cenário: consulta das candidaturas

- **Dado (Given):** que o usuário acessou `Minhas Candidaturas`.
1. **Quando (When):** a página for carregada.
2. **Então (Then):** o sistema deve consultar e apresentar as candidaturas pertencentes ao usuário autenticado.

---

## STORY-031 — Visualizar resumo da candidatura

**Como** usuário,
**quero** visualizar informações resumidas das vagas candidatas,
**para** identificá-las rapidamente.

### Cenário: exibição dos cards de candidatura

- **Dado (Given):** que existem candidaturas.
1. **Quando (When):** a lista for apresentada.
2. **Então (Then):** cada candidatura deve apresentar o resumo da respectiva vaga.

---

## STORY-032 — Visualizar mais informações

**Como** usuário,
**quero** visualizar os detalhes de uma candidatura,
**para** consultar todas as informações da vaga.

### Cenário: abertura dos detalhes

- **Dado (Given):** que uma candidatura está sendo exibida.
1. **Quando (When):** selecionar `Mais Informações`.
2. **Então (Then):** o sistema deve apresentar os detalhes completos da vaga correspondente.

> **Dependência:** ainda é necessário definir se os detalhes serão apresentados em página, modal ou drawer.

---

## STORY-033 — Retornar às vagas disponíveis

**Como** usuário,
**quero** retornar às vagas disponíveis,
**para** continuar procurando oportunidades.

### Cenário: retorno à listagem

- **Dado (Given):** que o usuário está em `Minhas Candidaturas`.
1. **Quando (When):** selecionar `Vagas Disponíveis`.
2. **Então (Then):** o sistema deve retornar à listagem de vagas.

---

## STORY-034 — Exibir candidaturas vazias

**Como** usuário,
**quero** ser informado quando ainda não possuo candidaturas,
**para** compreender o estado da página.

### Cenário: nenhuma candidatura encontrada

- **Dado (Given):** que o usuário não possui candidaturas.
1. **Quando (When):** a consulta for concluída.
2. **Então (Then):** o sistema deve apresentar um estado vazio apropriado.

---

## STORY-035 — Exibir carregamento das candidaturas

**Como** usuário,
**quero** visualizar quando minhas candidaturas estão sendo carregadas,
**para** compreender que a consulta está em andamento.

### Cenário: carregamento das candidaturas

- **Dado (Given):** que a consulta das candidaturas foi iniciada.
1. **Quando (When):** os dados ainda estiverem sendo carregados.
2. **Então (Then):** o sistema deve apresentar um estado de carregamento.

---

## STORY-036 — Tratar erro ao carregar candidaturas

**Como** usuário,
**quero** ser informado quando minhas candidaturas não puderem ser carregadas,
**para** poder tentar novamente.

### Cenário: falha na consulta das candidaturas

- **Dado (Given):** que ocorreu uma falha na consulta das candidaturas.
1. **Quando (When):** a operação retornar erro.
2. **Então (Then):** o sistema deve apresentar feedback de erro e permitir nova tentativa quando aplicável.

---

# Épico 6 — Criar vaga

## STORY-037 — Acessar cadastro de vaga

**Como** usuário,
**quero** acessar o cadastro de vagas,
**para** publicar uma oportunidade.

### Cenário: abertura do cadastro

- **Dado (Given):** que o usuário está autenticado.
1. **Quando (When):** selecionar `Criar Vaga`.
2. **Então (Then):** o sistema deve apresentar o formulário de cadastro de vaga.

---

## STORY-038 — Informar dados básicos

**Como** usuário,
**quero** informar os dados da vaga,
**para** descrevê-la corretamente.

### Cenário: preenchimento dos dados básicos

- **Dado (Given):** que o usuário está no formulário de criação.
1. **Quando (When):** preencher os campos da oportunidade.
2. **Então (Then):** o frontend deve manter os valores informados no estado do formulário.

---

## STORY-039 — Selecionar tipo de emprego

**Como** usuário,
**quero** informar o tipo de emprego,
**para** classificar a oportunidade.

### Cenário: seleção do tipo de emprego

- **Dado (Given):** que o formulário está aberto.
1. **Quando (When):** selecionar uma opção em `Tipo de Emprego`.
2. **Então (Then):** o valor selecionado deve ser associado à vaga.

---

## STORY-040 — Informar remuneração

**Como** usuário,
**quero** informar a remuneração,
**para** comunicar o pagamento oferecido.

### Cenário: preenchimento da remuneração

- **Dado (Given):** que o usuário está preenchendo uma vaga.
1. **Quando (When):** informar a remuneração.
2. **Então (Then):** o sistema deve aceitar somente um valor válido e representá-lo no formato definido pela aplicação.

---

## STORY-041 — Informar contato

**Como** usuário,
**quero** cadastrar e-mail e telefone de contato,
**para** permitir comunicação relacionada à vaga.

### Cenário: preenchimento dos dados de contato

- **Dado (Given):** que o formulário está aberto.
1. **Quando (When):** informar e-mail e telefone.
2. **Então (Then):** os dados devem ser validados e associados à vaga quando válidos.

---

# Épico 7 — Vaga presencial

## STORY-042 — Criar vaga presencial

**Como** usuário,
**quero** cadastrar uma vaga presencial,
**para** informar onde o trabalho será realizado.

### Cenário: formulário presencial

- **Dado (Given):** que `Trabalho Remoto` não está selecionado.
1. **Quando (When):** o formulário de criação for exibido.
2. **Então (Then):** os campos necessários para localização presencial devem estar disponíveis.

---

## STORY-043 — Informar endereço

**Como** usuário,
**quero** informar o endereço da oportunidade,
**para** indicar onde o trabalho acontecerá.

### Cenário: preenchimento do endereço

- **Dado (Given):** que a vaga é presencial.
1. **Quando (When):** preencher endereço, número e demais dados de localização.
2. **Então (Then):** o sistema deve associar a localização informada à vaga.

---

## STORY-044 — Selecionar estado da vaga

**Como** usuário,
**quero** selecionar o estado da vaga,
**para** completar sua localização.

### Cenário: seleção do estado

- **Dado (Given):** que a vaga é presencial e o campo `Estado` está disponível.
1. **Quando (When):** selecionar um estado.
2. **Então (Then):** o estado escolhido deve ser associado à localização da vaga.

---

## STORY-045 — Selecionar cidade da vaga

**Como** usuário,
**quero** selecionar a cidade da vaga,
**para** completar sua localização.

### Cenário: seleção da cidade

- **Dado (Given):** que existe um estado selecionado.
1. **Quando (When):** selecionar uma cidade.
2. **Então (Then):** a cidade escolhida deve pertencer ao estado selecionado e ser associada à vaga.

---

# Épico 8 — Trabalho remoto

## STORY-046 — Marcar vaga como remota

**Como** usuário,
**quero** indicar que a vaga é remota,
**para** não precisar fornecer uma localização física.

### Cenário: ativação do trabalho remoto

- **Dado (Given):** que o usuário está preenchendo uma vaga.
1. **Quando (When):** ativar `Trabalho Remoto`.
2. **Então (Then):** o sistema deve classificar a vaga como remota.

---

## STORY-047 — Adaptar formulário para trabalho remoto

**Como** usuário,
**quero** que o formulário se adapte quando a vaga for remota,
**para** preencher apenas as informações aplicáveis.

### Cenário: atualização do formulário remoto

- **Dado (Given):** que `Trabalho Remoto` foi ativado.
1. **Quando (When):** o estado do formulário for atualizado.
2. **Então (Then):** os campos de endereço presencial devem deixar de ser obrigatórios e a interface deve assumir a versão de vaga remota.

---

## STORY-048 — Alternar entre remoto e presencial

**Como** usuário,
**quero** alterar a modalidade de localização da vaga,
**para** corrigir minha escolha antes da publicação.

### Cenário: alternância da modalidade

- **Dado (Given):** que o formulário ainda não foi submetido.
1. **Quando (When):** alternar o controle `Trabalho Remoto`.
2. **Então (Then):** o formulário deve atualizar os campos e regras correspondentes à modalidade selecionada.

---

# Épico 9 — Conteúdo da vaga

## STORY-049 — Informar descrição

**Como** usuário,
**quero** descrever a oportunidade,
**para** explicar suas atividades e características.

### Cenário: preenchimento da descrição

- **Dado (Given):** que o formulário de vaga está aberto.
1. **Quando (When):** preencher `Descrição da Vaga`.
2. **Então (Then):** o conteúdo deve ser mantido e associado à vaga.

---

## STORY-050 — Informar requisitos

**Como** usuário,
**quero** informar os requisitos da oportunidade,
**para** comunicar o perfil necessário.

### Cenário: preenchimento dos requisitos

- **Dado (Given):** que o formulário de vaga está aberto.
1. **Quando (When):** preencher `Requisitos`.
2. **Então (Then):** o conteúdo deve ser mantido e associado à vaga.

---

# Épico 10 — Validação da vaga

## STORY-051 — Validar campos obrigatórios

**Como** usuário,
**quero** saber quais campos obrigatórios estão ausentes,
**para** corrigir o formulário.

### Cenário: tentativa de publicação com campos inválidos

- **Dado (Given):** que existem campos obrigatórios inválidos ou vazios.
1. **Quando (When):** tentar cadastrar a vaga.
2. **Então (Then):** o sistema deve impedir a publicação e apresentar os erros correspondentes.

---

## STORY-052 — Exibir erro no campo correspondente

**Como** usuário,
**quero** visualizar o erro próximo ao campo inválido,
**para** identificar rapidamente o que precisa ser corrigido.

### Cenário: erro de validação em campo

- **Dado (Given):** que determinado campo possui um valor inválido.
1. **Quando (When):** a validação for executada.
2. **Então (Then):** o erro deve ser apresentado de forma associada ao campo responsável.

---

## STORY-053 — Preservar formulário após erro

**Como** usuário,
**quero** manter meus dados quando ocorrer um erro,
**para** não precisar preencher o formulário novamente.

### Cenário: erro após preenchimento

- **Dado (Given):** que o formulário contém informações preenchidas.
1. **Quando (When):** uma validação ou operação de cadastro falhar.
2. **Então (Then):** os valores informados pelo usuário devem permanecer disponíveis.

---

# Épico 11 — Rascunhos

## STORY-054 — Salvar vaga como rascunho

**Como** usuário,
**quero** salvar uma vaga como rascunho,
**para** continuar seu preenchimento posteriormente.

### Cenário: salvamento de rascunho

- **Dado (Given):** que o usuário iniciou o preenchimento de uma vaga.
1. **Quando (When):** selecionar `Salvar Rascunho`.
2. **Então (Then):** o sistema deve persistir a vaga com estado de rascunho.

---

## STORY-055 — Salvar rascunho incompleto

**Como** usuário,
**quero** salvar uma vaga incompleta,
**para** terminar seu preenchimento posteriormente.

### Cenário: rascunho com campos de publicação ausentes

- **Dado (Given):** que alguns campos obrigatórios para publicação não estão preenchidos.
1. **Quando (When):** selecionar `Salvar Rascunho`.
2. **Então (Then):** o sistema deve permitir o salvamento desde que os requisitos mínimos de identificação do rascunho sejam satisfeitos.

---

## STORY-056 — Recuperar rascunho

**Como** usuário,
**quero** abrir novamente um rascunho,
**para** continuar sua edição.

### Cenário: reabertura de rascunho

- **Dado (Given):** que existe uma vaga salva como rascunho.
1. **Quando (When):** o usuário selecionar o rascunho para edição.
2. **Então (Then):** o formulário deve ser carregado com os dados anteriormente salvos.

> **Gap atual:** o mockup ainda não mostra onde os rascunhos serão listados.

---

# Épico 12 — Publicação

## STORY-057 — Publicar vaga

**Como** usuário,
**quero** cadastrar uma vaga,
**para** disponibilizá-la aos candidatos.

### Cenário: publicação válida

- **Dado (Given):** que todos os dados obrigatórios estão válidos.
1. **Quando (When):** selecionar `Cadastrar Vaga`.
2. **Então (Then):** o sistema deve enviar os dados e publicar a vaga quando a operação for aceita.

---

## STORY-058 — Evitar publicação duplicada

**Como** usuário,
**quero** que uma publicação seja processada apenas uma vez,
**para** evitar vagas duplicadas.

### Cenário: múltiplos cliques durante publicação

- **Dado (Given):** que uma publicação está em processamento.
1. **Quando (When):** o usuário tentar acionar novamente `Cadastrar Vaga`.
2. **Então (Then):** o sistema deve impedir uma segunda submissão simultânea.

---

## STORY-059 — Confirmar publicação

**Como** usuário,
**quero** receber confirmação da publicação,
**para** saber que minha vaga foi cadastrada.

### Cenário: publicação concluída

- **Dado (Given):** que a criação foi concluída com sucesso.
1. **Quando (When):** o frontend receber a confirmação.
2. **Então (Then):** deve apresentar feedback de sucesso e executar o comportamento pós-cadastro definido na spec.

---

## STORY-060 — Tratar erro na publicação

**Como** usuário,
**quero** ser informado quando a publicação falhar,
**para** corrigir o problema ou tentar novamente.

### Cenário: falha na publicação

- **Dado (Given):** que os dados foram enviados para publicação.
1. **Quando (When):** a operação falhar.
2. **Então (Then):** o sistema deve apresentar o erro, preservar os dados e permitir nova tentativa.

---

# Épico 13 — Perfil

## STORY-061 — Consultar perfil

**Como** usuário,
**quero** consultar meu perfil,
**para** visualizar minhas informações pessoais.

### Cenário: carregamento do perfil

- **Dado (Given):** que o usuário está autenticado.
1. **Quando (When):** acessar `Perfil`.
2. **Então (Then):** o sistema deve consultar e preencher o formulário com os dados do usuário.

---

## STORY-062 — Editar informações pessoais

**Como** usuário,
**quero** editar minhas informações,
**para** manter meu perfil atualizado.

### Cenário: edição de campo permitido

- **Dado (Given):** que o perfil foi carregado.
1. **Quando (When):** alterar um campo permitido.
2. **Então (Then):** o formulário deve manter o novo valor até que as alterações sejam persistidas.

---

## STORY-063 — Editar nome

**Como** usuário,
**quero** editar meu nome,
**para** manter minha identificação atualizada.

### Cenário: alteração do nome

- **Dado (Given):** que o usuário está editando seu perfil.
1. **Quando (When):** alterar `Nome Completo`.
2. **Então (Then):** o sistema deve aceitar o novo nome quando ele satisfizer as regras definidas.

---

## STORY-064 — Editar e-mail

**Como** usuário,
**quero** editar meu e-mail,
**para** manter meu contato atualizado.

### Cenário: alteração do e-mail

- **Dado (Given):** que o usuário está editando seu perfil.
1. **Quando (When):** informar um novo e-mail.
2. **Então (Then):** o sistema deve validar seu formato antes de permitir o salvamento.

---

## STORY-065 — Exibir ou editar CPF

**Como** usuário,
**quero** visualizar meu CPF de forma adequada,
**para** consultar o dado cadastrado.

### Cenário: exibição do CPF

- **Dado (Given):** que existe um CPF associado ao perfil.
1. **Quando (When):** o perfil for apresentado.
2. **Então (Then):** o CPF deve ser apresentado no formato definido para a aplicação.

> **Dependência de requisito:** a capacidade de alterar CPF precisa ser definida pelo domínio.

---

## STORY-066 — Editar telefone

**Como** usuário,
**quero** editar meu telefone,
**para** manter meu contato atualizado.

### Cenário: alteração do telefone

- **Dado (Given):** que o usuário está editando seu perfil.
1. **Quando (When):** alterar seu telefone.
2. **Então (Then):** o sistema deve validar e formatar o telefone conforme a regra definida.

---

## STORY-067 — Selecionar escolaridade

**Como** usuário,
**quero** informar minha escolaridade,
**para** complementar meu perfil profissional.

### Cenário: seleção da escolaridade

- **Dado (Given):** que as opções de escolaridade estão disponíveis.
1. **Quando (When):** selecionar uma opção.
2. **Então (Then):** a opção selecionada deve ser associada ao perfil.

---

## STORY-068 — Editar endereço

**Como** usuário,
**quero** informar meu endereço,
**para** manter meus dados de localização atualizados.

### Cenário: alteração do endereço

- **Dado (Given):** que o usuário está editando o perfil.
1. **Quando (When):** alterar o campo de endereço.
2. **Então (Then):** o novo valor deve ser mantido pelo formulário.

---

## STORY-069 — Selecionar estado

**Como** usuário,
**quero** selecionar meu estado,
**para** completar minha localização.

### Cenário: alteração do estado

- **Dado (Given):** que as opções de estado estão disponíveis.
1. **Quando (When):** selecionar um estado.
2. **Então (Then):** o sistema deve associar o estado ao perfil e atualizar as cidades disponíveis quando necessário.

---

## STORY-070 — Selecionar cidade

**Como** usuário,
**quero** selecionar minha cidade,
**para** completar minha localização.

### Cenário: alteração da cidade

- **Dado (Given):** que existe um estado selecionado.
1. **Quando (When):** selecionar uma cidade.
2. **Então (Then):** a cidade deve ser compatível com o estado e ser associada ao perfil.

---

## STORY-071 — Editar “Sobre você”

**Como** usuário,
**quero** escrever informações sobre mim,
**para** complementar meu perfil profissional.

### Cenário: edição da apresentação pessoal

- **Dado (Given):** que o perfil está em edição.
1. **Quando (When):** informar conteúdo em `Sobre você`.
2. **Então (Then):** o texto deve ser mantido e posteriormente persistido com o perfil.

---

# Épico 14 — Interesses profissionais

## STORY-072 — Consultar interesses

**Como** usuário,
**quero** visualizar meus interesses profissionais,
**para** compreender minhas preferências cadastradas.

### Cenário: exibição dos interesses

- **Dado (Given):** que o perfil possui interesses.
1. **Quando (When):** a página de perfil for carregada.
2. **Então (Then):** os interesses atuais devem ser apresentados.

---

## STORY-073 — Adicionar interesse

**Como** usuário,
**quero** adicionar um interesse profissional,
**para** indicar os tipos de oportunidade que procuro.

### Cenário: adição de interesse

- **Dado (Given):** que existem interesses disponíveis para seleção.
1. **Quando (When):** selecionar um interesse ainda não cadastrado.
2. **Então (Then):** o interesse deve ser adicionado à seleção do usuário.

---

## STORY-074 — Exibir interesses selecionados

**Como** usuário,
**quero** visualizar individualmente meus interesses selecionados,
**para** saber quais preferências estão associadas ao meu perfil.

### Cenário: representação dos interesses

- **Dado (Given):** que um ou mais interesses foram selecionados.
1. **Quando (When):** a área de interesses for apresentada.
2. **Então (Then):** cada interesse deve aparecer individualmente de forma identificável na interface.

---

## STORY-075 — Remover interesse

**Como** usuário,
**quero** remover um interesse,
**para** atualizar minhas preferências.

### Cenário: remoção de interesse

- **Dado (Given):** que existe um interesse selecionado.
1. **Quando (When):** selecionar a ação de remoção desse interesse.
2. **Então (Then):** o interesse deve deixar de fazer parte da seleção.

---

## STORY-076 — Impedir interesse duplicado

**Como** usuário,
**quero** que um interesse seja cadastrado apenas uma vez,
**para** evitar duplicidade no perfil.

### Cenário: tentativa de adicionar interesse existente

- **Dado (Given):** que determinado interesse já está selecionado.
1. **Quando (When):** o usuário tentar adicioná-lo novamente.
2. **Então (Then):** o sistema deve impedir sua duplicação.

---

# Épico 15 — Persistência do perfil

## STORY-077 — Salvar alterações do perfil

**Como** usuário,
**quero** salvar as alterações realizadas,
**para** manter meu perfil atualizado.

### Cenário: salvamento do perfil

- **Dado (Given):** que o usuário alterou informações válidas do perfil.
1. **Quando (When):** executar a ação de salvar.
2. **Então (Then):** o sistema deve persistir os novos dados.

> **Gap do mockup:** atualmente não existe botão `Salvar` nem especificação de autosave. Recomenda-se adicionar explicitamente a ação `Salvar alterações`.

---

## STORY-078 — Validar perfil

**Como** usuário,
**quero** ser informado sobre dados inválidos no perfil,
**para** corrigi-los antes do salvamento.

### Cenário: tentativa de salvar perfil inválido

- **Dado (Given):** que existem informações inválidas no perfil.
1. **Quando (When):** o usuário tentar salvar as alterações.
2. **Então (Then):** o sistema deve impedir o envio e apresentar os erros associados aos campos.

---

## STORY-079 — Confirmar atualização do perfil

**Como** usuário,
**quero** receber confirmação após atualizar meu perfil,
**para** saber que os dados foram persistidos.

### Cenário: atualização concluída

- **Dado (Given):** que a atualização foi processada com sucesso.
1. **Quando (When):** o frontend receber a confirmação.
2. **Então (Then):** deve apresentar feedback indicando que o perfil foi atualizado.

---

## STORY-080 — Tratar erro na atualização

**Como** usuário,
**quero** ser informado quando a atualização do perfil falhar,
**para** tentar novamente sem perder minhas alterações.

### Cenário: falha ao salvar perfil

- **Dado (Given):** que o usuário enviou alterações válidas.
1. **Quando (When):** a atualização falhar.
2. **Então (Then):** o sistema deve informar o erro, preservar as alterações e permitir uma nova tentativa.

---

# Épico 16 — Estados assíncronos

## STORY-081 — Exibir estado de loading

**Como** usuário,
**quero** visualizar quando uma operação está sendo processada,
**para** compreender o estado do sistema.

### Cenário: operação em andamento

- **Dado (Given):** que uma operação assíncrona foi iniciada.
1. **Quando (When):** a resposta ainda estiver pendente.
2. **Então (Then):** a interface deve apresentar um estado de processamento apropriado.

---

## STORY-082 — Exibir estado de erro

**Como** usuário,
**quero** receber feedback quando uma operação falhar,
**para** entender o que ocorreu.

### Cenário: operação concluída com erro

- **Dado (Given):** que uma operação terminou com falha.
1. **Quando (When):** a interface receber o resultado de erro.
2. **Então (Then):** deve apresentar um estado de erro apropriado em vez de aparentar ausência normal de conteúdo.

---

## STORY-083 — Tentar novamente

**Como** usuário,
**quero** repetir uma operação recuperável,
**para** continuar utilizando a funcionalidade após uma falha temporária.

### Cenário: nova tentativa

- **Dado (Given):** que uma consulta recuperável falhou.
1. **Quando (When):** o usuário selecionar a ação de tentar novamente.
2. **Então (Then):** o sistema deve executar uma nova tentativa da operação.

---

## STORY-084 — Evitar operações duplicadas

**Como** usuário,
**quero** que uma ação seja processada apenas uma vez,
**para** evitar registros duplicados.

### Cenário: ação já em processamento

- **Dado (Given):** que uma mutation está em processamento.
1. **Quando (When):** o usuário tentar disparar a mesma operação novamente.
2. **Então (Then):** o sistema deve impedir uma nova execução concorrente.

---

# Épico 17 — Comportamento dos formulários

## STORY-085 — Preservar dados preenchidos

**Como** usuário,
**quero** que os dados digitados permaneçam no formulário,
**para** não perder trabalho durante a interação.

### Cenário: atualização do estado do formulário

- **Dado (Given):** que o usuário já preencheu informações no formulário.
1. **Quando (When):** ocorrer uma atualização normal de estado ou uma validação.
2. **Então (Then):** os campos que não precisam ser alterados devem manter seus valores.

---

## STORY-086 — Normalizar entradas

**Como** usuário,
**quero** que entradas formatáveis sejam tratadas de maneira consistente,
**para** reduzir erros de preenchimento.

### Cenário: entrada com regra de formatação

- **Dado (Given):** que o usuário está preenchendo um campo que possui regra de formatação.
1. **Quando (When):** informar seu valor.
2. **Então (Then):** o frontend deve normalizar ou formatar o valor de acordo com o contrato daquele campo.

Abrange, quando aplicável:

- CPF.
- Telefone.
- Remuneração.
- E-mail.
- Espaços excedentes.

---

## STORY-087 — Identificar campos obrigatórios

**Como** usuário,
**quero** identificar quais informações são obrigatórias,
**para** saber o que preciso preencher.

### Cenário: exibição de obrigatoriedade

- **Dado (Given):** que determinado campo é obrigatório no cenário atual.
1. **Quando (When):** o formulário for apresentado.
2. **Então (Then):** o campo deve possuir uma indicação visual consistente de obrigatoriedade.

---

## STORY-088 — Impedir submissão inválida

**Como** usuário,
**quero** ser impedido de enviar informações inválidas,
**para** corrigir os problemas antes do processamento.

### Cenário: submissão inválida

- **Dado (Given):** que o formulário possui pelo menos uma violação de validação conhecida pelo frontend.
1. **Quando (When):** o usuário tentar submetê-lo.
2. **Então (Then):** o frontend deve impedir a submissão, apresentar os erros e manter os dados já preenchidos.

---

# Lacunas funcionais identificadas nos mockups

Antes de considerar todas as stories como **Ready**, os seguintes pontos precisam ser definidos:

## 1. Filtros de vagas

Existe a ação `Filtrar`, mas o mockup não define:

- quais filtros estarão disponíveis;
- quais valores poderão ser selecionados;
- se a interface será modal, drawer, popover ou área fixa;
- como os filtros serão aplicados e limpos.

## 2. Detalhes da candidatura

Existe a ação `Mais Informações`, porém não há definição da interface de detalhes.

Deve ser definido se será:

- nova página;
- modal;
- drawer.

Também precisam ser definidos os campos exibidos.

## 3. Recuperação de rascunhos

Existe `Salvar Rascunho`, mas não existe uma interface mostrando:

- onde os rascunhos serão listados;
- como serão reabertos;
- se poderão ser excluídos;
- se haverá indicação de data da última alteração.

## 4. Salvamento do perfil

A tela de perfil apresenta campos editáveis, mas não define:

- botão `Salvar alterações`; ou
- comportamento de autosave.

A recomendação é utilizar uma ação explícita `Salvar alterações`.

## 5. Alteração de CPF

O mockup apresenta CPF no formulário do perfil, mas é necessário definir se:

- o CPF é somente leitura; ou
- pode ser alterado após o cadastro.

---

# Organização sugerida das specs

As 88 stories não precisam corresponder a 88 arquivos.

Uma organização possível:

```text
specs/
├── authentication/
│   ├── spec.md
│   ├── design.md
│   ├── tasks.md
│   └── validation.md  # após implementação
├── vacancy-discovery/
│   ├── spec.md
│   ├── design.md
│   ├── tasks.md
│   └── validation.md  # após implementação
├── job-applications/
│   ├── spec.md
│   ├── design.md
│   ├── tasks.md
│   └── validation.md  # após implementação
├── vacancy-management/
│   ├── spec.md
│   ├── design.md
│   ├── tasks.md
│   └── validation.md  # após implementação
└── user-profile/
    ├── spec.md
    ├── design.md
    ├── tasks.md
    └── validation.md  # após implementação
```

`validation.md` não participa do Ready Gate; ele é criado pela verificação
independente após a implementação. Os exemplos são não normativos.

## Agrupamento sugerido

### authentication

Inclui:

- STORY-001 a STORY-012.

### vacancy-discovery

Inclui:

- STORY-013 a STORY-024.

### job-applications

Inclui:

- STORY-025 a STORY-036.

### vacancy-management — creation

Inclui:

- STORY-037 a STORY-053.
- STORY-057 a STORY-060.

### vacancy-management — drafts

Inclui:

- STORY-054 a STORY-056.

### user-profile

Inclui:

- STORY-061 a STORY-080.

### requisitos transversais

STORY-081 a STORY-088 são comportamentos transversais e podem ser:

- incorporados como cenários nas specs correspondentes; ou
- mantidos em uma seção compartilhada de requisitos de frontend.

Para Spec-Driven Development, a abordagem preferível é incorporá-los aos critérios de aceitação das funcionalidades que realmente dependem desses comportamentos, evitando transformar loading, erro e validações genéricas em features isoladas.
