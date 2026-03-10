# Plano Único de Execução

Documento único para substituir a separação entre checklist e sprint plan.

Fontes usadas:
- `docs/internal/PLAN.md`
- `docs/internal/PLANO_TELAS_MOCKUP.md`
- `docs/internal/UI_PLAN.md`
- estado atual do código em `lib/`
- mock final aprovado

## Legenda
- `[x]` concluído no código atual
- `[-]` parcialmente pronto
- `[ ]` pendente

## Regra de uso deste documento
Cada bloco abaixo já combina:
- prioridade
- sprint sugerido
- status atual
- entregáveis
- critério de aceite

Se um item mudar de ordem durante a execução, a referência continua sendo este documento. Não é necessário comparar com outro plano.

## Sprint 0.5: UI Alignment Pass
Prioridade:
alta

Objetivo:
alinhar as telas reais já implementadas ao mock final antes de continuar expandindo fluxos em cima de UI desalinhada.

### 0.5.1 Entrada e identidade
- [x] `SplashScreen` implementar
- [x] navegação inicial abrir splash antes da shell principal

### 0.5.2 Ajustes visuais prioritarios
- [x] `Weight Check-in` alinhar ao mock final
- [x] `Weekly Diet Report` alinhar ao mock final

Critério de aceite:
- entrada do app reflete a identidade visual aprovada
- telas críticas deixam de divergir estruturalmente do mock final

## Sprint 1: Navegação real e pontos de entrada
Prioridade:
alta

Objetivo:
tirar o app do estado de mock parcialmente navegável.

### 1.1 Shell principal
- [x] `AppShellScreen` com `IndexedStack`
- [x] Bottom navigation principal
- [x] FAB central visual no contexto Daily
- [x] Daily e Home já apontam para telas reais
- [x] Plans deixar de usar placeholder
- [x] History deixar de usar placeholder
- [x] FAB central abrir fluxo real de scanner

Critério de aceite:
- nenhuma aba principal exibe placeholder
- nenhuma ação principal da shell fica vazia

### 1.2 Rotas internas obrigatórias
- [-] Scanner
- [x] Settings
- [x] Food Database
- [-] Weight Check-in

Critério de aceite:
- usuário consegue abrir manualmente todas essas telas a partir dos pontos visíveis da UI

### 1.3 Ações hoje vazias
- [x] settings no Home
- [x] settings no Daily
- [x] settings no Dashboard
- [x] quick action `Scan Food`
- [x] quick action `Log Weight`
- [x] CTA de scanner no Daily

Critério de aceite:
- eliminar `onTap: () {}` dos fluxos principais

Observação:
- câmera real não precisa bloquear o Sprint 1
- o scanner pode entrar primeiro como tela visual com entrada manual funcional

## Sprint 2: Perfis reais e estado global do gato
Prioridade:
alta

Objetivo:
trocar dados hardcoded por perfis reais persistidos.

### 2.1 Base técnica
- [x] `HiveService` inicializado
- [x] `CatProfile`, `FoodItem`, `WeightRecord`
- [x] adapters gerados e registrados
- [x] app com `ProviderScope`
- [ ] providers/repositories conectando UI aos dados reais
- [ ] provider de gato ativo global

Critério de aceite:
- estado principal do gato não depende mais de mocks locais de widget

### 2.2 Tela Cat Profile
- [ ] tela final aderente ao mock
- [ ] formulário completo: nome, peso, idade
- [ ] campos de castração, atividade e objetivo
- [ ] seleção de foto
- [ ] validação
- [ ] salvar perfil
- [ ] editar perfil
- [ ] excluir perfil

Base atual:
- [x] existe `ProfileListScreen`
- [-] tela atual ainda é showcase e não fluxo final

Critério de aceite:
- criar, editar e excluir um gato altera o estado real do app

### 2.3 Home com dados reais
- [x] header visual
- [x] carrossel visual
- [x] next feeding card
- [x] insights card
- [x] stats grid
- [-] dados ainda mockados
- [ ] `Add New` abrir cadastro real
- [ ] seleção de gato atualizar estado global
- [ ] dados vindos de Hive/Riverpod
- [ ] empty state real quando não houver gato

Critério de aceite:
- Home reflete apenas dados persistidos

## Sprint 3: Entrada operacional de dados
Prioridade:
alta

Objetivo:
fechar os fluxos que alimentam o produto com dados reais.

Documento de apoio:
- `docs/internal/FOOD_DATABASE_PLAN.md`

### 3.1 Food Database
- [x] tela de Food Database
- [x] busca por nome/marca/tipo
- [x] atalho `Scan Barcode`
- [x] atalho `Add Manually`
- [ ] lista de itens recentes/populares
- [x] salvar alimentos no Hive
- [x] reaproveitar alimentos no app

Critério de aceite:
- usuário consegue cadastrar e recuperar alimentos reais

### 3.2 Scanner de alimento
- [x] tela visual do scanner
- [ ] overlay alinhado ao mock
- [ ] flash
- [x] fallback `Manual Entry`
- [ ] card inferior de confirmação
- [-] ação `Confirm Product`
- [x] navegação a partir do FAB e quick actions
- [ ] integração com câmera
- [ ] leitura de barcode via ML Kit

Critério de aceite:
- fallback manual é funcional mesmo sem câmera
- se câmera estiver ativa, leitura retorna para fluxo de confirmação

### 3.3 Weight Check-in
- [x] tela dedicada de peso
- [ ] exibição do gato selecionado
- [x] valor atual
- [x] ajuste de novo peso
- [x] observações
- [x] CTA `Record Weight`
- [x] persistir histórico no Hive
- [-] atualizar resumos após salvar

Critério de aceite:
- registrar peso gera histórico persistido e altera os cards relevantes

## Sprint 4: Plans, Daily real e regras de negócio
Prioridade:
alta

Objetivo:
fazer o fluxo principal do produto funcionar de ponta a ponta.

### 4.1 Regras de negócio
- [x] implementar `DietCalculatorService`
- [ ] fórmulas RER/MER
- [ ] validar inputs
- [-] cálculo de porção por refeição
- [ ] metas de manutenção/perda/ganho
- [ ] alertas de saúde por faixa
- [ ] salvar plano alimentar atual

Critério de aceite:
- cálculo gera plano consistente a partir de gato + alimento + objetivo

### 4.2 Plans
- [x] criar tela/fluxo real de `Plans`
- [x] substituir placeholder da aba
- [ ] permitir selecionar gato e alimento
- [-] exibir meta calórica diária
- [-] exibir porção por refeição
- [ ] persistir plano

Critério de aceite:
- aba `Plans` deixa de ser mock e salva dados utilizáveis no app

### 4.3 Daily Dashboard real
- [x] header visual
- [x] cards de métricas
- [x] agenda visual
- [x] CTA visual
- [-] dados ainda estáticos
- [ ] marcar refeições como concluídas
- [ ] registrar check-in de peso pelo fluxo diário
- [ ] persistir schedule/refeições do dia
- [ ] navegação real para scanner e peso

Critério de aceite:
- Daily passa a refletir o plano salvo e a execução do dia

## Sprint 5: Dashboard analítico e relatório
Prioridade:
média

Objetivo:
fechar histórico, evolução e compartilhamento.

### 5.1 Health Dashboard conectado
- [x] app bar visual
- [x] hero do gato
- [x] quick actions visuais
- [x] daily summary card
- [x] meal timeline visual
- [-] dados reais ainda ausentes
- [ ] resumo diário conectado ao estado real
- [ ] timeline conectada a refeições reais
- [ ] ações rápidas com navegação/fluxo real

Critério de aceite:
- Dashboard detalhado deixa de ser apenas mock navegável

### 5.2 History / Weekly Diet Report
Documento de apoio:
- `usar este bloco como checklist inicial`

#### Bloco A: HistoryScreen real
- [x] criar tela real de `History`
- [x] substituir placeholder da aba `History`
- [x] estado vazio coerente quando nao houver historico

#### Bloco B: leitura local de historico
- [x] ler `WeightRecord` do Hive
- [x] listar registros reais por data
- [x] exibir valor e observacoes quando existirem

#### Bloco C: resumo visual
- [x] resumo do ultimo peso
- [x] resumo da variacao recente
- [x] tendencia simples de evolucao

#### Bloco D: Weekly Diet Report
- [x] tela de `Weekly Diet Report`
- [-] gráfico de tendência de peso
- [-] tabela de calorias por dia
- [-] notas veterinárias

#### Bloco E: exportacao e compartilhamento
- [ ] `Download PDF`
- [ ] `Share via WhatsApp`
- [ ] exportação PDF real

Critério de aceite:
- usuário consegue abrir histórico e gerar relatório semanal

## Sprint 6: Settings persistentes, notificações e acabamento
Prioridade:
média

Objetivo:
encerrar o app como produto utilizável.

### 6.1 Settings
- [x] tela de configurações
- [-] toggle de reminders
- [ ] configuração de horários
- [x] dark mode
- [ ] idioma
- [ ] export JSON
- [ ] backup
- [ ] persistência local das preferências

Critério de aceite:
- preferências sobrevivem ao restart

### 6.2 Notificações
- [ ] solicitar permissões
- [ ] agendar refeições locais
- [ ] payload por gato/refeição
- [ ] snooze
- [ ] repetir amanhã
- [ ] integrar com Settings

Critério de aceite:
- rotina diária pode ser lembrada automaticamente

### 6.3 Qualidade e fechamento
- [ ] remover placeholders restantes
- [ ] remover dados mockados das telas finais
- [ ] loading/skeleton states consistentes
- [ ] error/empty states consistentes
- [ ] responsividade em telas pequenas
- [ ] revisão visual final contra mock
- [ ] testes de widget da navegação
- [ ] testes do formulário de perfil
- [ ] testes do registro de peso
- [ ] testes de persistência Hive

Critério de aceite:
- app fecha sem pendências estruturais visíveis

## Diagnóstico atual
- O projeto já tem a base visual principal do design system.
- `Home`, `Daily Overview` e `Health Dashboard` já existem como mock funcional.
- A principal dívida atual é fluxo real, não layout.
- O maior ganho de velocidade vem de eliminar placeholders e `onTap` vazios antes de aprofundar regras de negócio.

## Ordem imediata recomendada
1. `Settings`
2. `Weight Check-in`
3. `Food Database`
4. `Scanner`
5. aba `Plans`
6. aba `History`

Motivo:
- isso destrava navegação, reduz ações mortas e cria base para os sprints seguintes.
