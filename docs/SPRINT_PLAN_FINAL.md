# Plano de Execução por Sprint

> Obsoleto como fonte principal. Usar `docs/EXECUTION_PLAN.md`.

Baseado em [CHECKLIST_FINAL.md](/run/media/mateus/f8271cf2-fe57-43a3-a203-4b4c407bd599/CatDiet/cat_diet_planner/docs/CHECKLIST_FINAL.md) e no estado atual do código.

## Princípio de execução
Ordem correta para este projeto:
1. fechar navegação real
2. fechar CRUD e estado do gato ativo
3. conectar fluxos de entrada de dados
4. fechar analytics e relatório
5. fazer acabamento, persistência avançada e testes

Se inverter isso, o time vai produzir tela bonita sem fluxo utilizável.

## Sprint 1: Navegação real e telas de suporte
Objetivo:
tirar o app do estado de mock parcialmente navegável e fechar os pontos de entrada principais.

Entregáveis:
- substituir placeholders `Plans` e `History`
- criar rotas/telas reais para:
  - Scanner
  - Settings
  - Food Database
  - Weight Check-in
- conectar ações que hoje estão vazias:
  - FAB central do `AppShellScreen`
  - botão de settings no Home
  - botão de settings no Daily
  - quick actions no Dashboard

Escopo técnico:
- criar pastas base em `lib/features/scanner/`
- criar pastas base em `lib/features/settings/`
- criar pastas base em `lib/features/food_database/`
- criar pastas base em `lib/features/weight/`
- extrair navegação para rotas consistentes via `Navigator`

Critério de aceite:
- nenhuma ação principal do app fica com `onTap: () {}`
- nenhuma aba principal mostra placeholder
- usuário consegue abrir manualmente todas as telas do mock final que dependem de navegação básica

Risco:
- tentar integrar câmera real já nesta sprint pode atrasar demais

Corte pragmático:
- nesta sprint, o Scanner pode nascer primeiro como tela visual + fluxo manual funcional
- integração real com câmera/barcode entra no Sprint 3

## Sprint 2: Perfis, estado global e dados reais base
Objetivo:
fazer o app trabalhar com gatos reais em vez de dados hardcoded.

Entregáveis:
- implementar tela final de `Cat Profile`
- CRUD de perfil:
  - criar
  - editar
  - excluir
- definir gato ativo global
- fazer Home e Dashboard consumirem perfis reais do Hive
- fazer ação "Add New" abrir o formulário real

Escopo técnico:
- provider para lista de gatos
- provider para gato ativo
- integração entre formulário e `HiveService`
- refatorar widgets que hoje fabricam dados mockados localmente

Critério de aceite:
- abrir o app com box vazia mostra empty state real
- criar um gato novo atualiza Home e Dashboard
- trocar gato ativo altera os dados exibidos nas telas
- reiniciar o app preserva perfis e gato selecionado

Dependências:
- Sprint 1 concluída para permitir navegação ao formulário e telas associadas

## Sprint 3: Scanner, base de alimentos e check-in de peso
Objetivo:
fechar os fluxos de entrada operacional do produto.

Entregáveis:
- scanner de alimento funcional
- fluxo manual de cadastro de alimento funcional
- `Food Database` conectada ao Hive
- `Weight Check-in` conectado ao histórico de peso
- quick actions funcionando de ponta a ponta

Escopo técnico:
- salvar `FoodItem` no Hive
- buscar/listar alimentos na `Food Database`
- registrar `WeightRecord` no perfil do gato
- integrar câmera e barcode, se viável no ambiente atual
- fallback manual obrigatório mesmo se câmera falhar

Critério de aceite:
- usuário consegue cadastrar um alimento manualmente
- alimento aparece na base e pode ser reutilizado
- usuário consegue registrar um novo peso
- novo peso atualiza histórico e cards/resumos relevantes

Risco:
- câmera/ML Kit pode exigir ajuste de plataforma

Corte pragmático:
- se houver bloqueio nativo, manter input manual funcional e isolar scanner real como subentrega técnica

## Sprint 4: Plans, Daily real e regras de negócio
Objetivo:
substituir telas mockadas por comportamento real de dieta e rotina diária.

Entregáveis:
- implementar `DietCalculatorService`
- criar tela/fluxo de `Plans`
- persistir plano alimentar atual
- ligar `Daily Dashboard` a refeições reais
- permitir marcar refeição como concluída
- permitir rotina de check-in dentro do fluxo diário

Escopo técnico:
- fórmula RER/MER
- cálculo de porções por refeição
- modelo de plano/refeição diária
- provider para consumo diário
- integração com `FoodItem` e perfil ativo

Critério de aceite:
- usuário escolhe gato e alimento
- app calcula meta diária e porção
- plano é salvo
- Daily mostra refeições reais e progresso do dia

Dependências:
- Sprint 2 e 3 precisam estar fechadas

## Sprint 5: History, Weekly Report, export e share
Objetivo:
fechar o bloco analítico do app.

Entregáveis:
- tela `History`
- tela `Weekly Diet Report`
- gráfico de tendência de peso
- tabela de calorias por dia
- notas/resumo veterinário
- exportação PDF
- compartilhamento

Escopo técnico:
- consolidar dados de peso e intake diário
- usar `fl_chart`
- gerar PDF com `pdf` + `printing`
- share com `share_plus`

Critério de aceite:
- aba `History` deixa de ser placeholder
- relatório semanal abre com dados do gato ativo
- PDF é gerado e compartilhável

## Sprint 6: Settings, notificações, persistência avançada e qualidade
Objetivo:
fechar o produto como app utilizável e não só demo navegável.

Entregáveis:
- settings persistentes
- reminders locais
- idioma
- export JSON / backup
- revisão responsiva
- testes críticos

Escopo técnico:
- persistir tema, idioma e reminders
- notificações locais com payload
- exportação de dados
- testes de widget e integração leve

Critério de aceite:
- preferências sobrevivem ao restart
- notificações podem ser configuradas
- fluxos críticos possuem cobertura mínima de teste

## Ordem recomendada dentro de cada sprint
Sempre seguir esta sequência:
1. criar tela base
2. ligar navegação
3. conectar estado
4. persistir dados
5. revisar empty/error/loading
6. testar fluxo

## Backlog técnico transversal
Esses itens não devem abrir sprint própria, mas precisam ser puxados ao longo das entregas:
- remover `onTap` vazios
- trocar dados hardcoded por providers
- padronizar empty state
- padronizar mensagens de erro
- revisar espaçamento e fidelidade ao mock final
- garantir responsividade vertical em devices menores

## Marco de entrega realista
### Marco 1
Fim do Sprint 2:
- app sem placeholders principais
- perfis reais
- navegação completa básica

### Marco 2
Fim do Sprint 4:
- fluxo central do produto funcionando
- perfil -> alimento -> plano -> rotina diária

### Marco 3
Fim do Sprint 6:
- histórico, relatório, export, settings e notificações fechados

## Próxima execução recomendada
Começar pelo Sprint 1 nesta ordem:
1. `Settings`
2. `Weight Check-in`
3. `Food Database`
4. `Scanner`
5. troca das abas `Plans` e `History`

Motivo:
- `Settings` e `Weight Check-in` são baratos e destravam ações já visíveis
- `Food Database` cria a base para scanner/manual entry
- `Scanner` depende dessa base
- `Plans` e `History` ficam melhores depois que já existir dado real mínimo
