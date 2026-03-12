# Checklist Final de Entrega

Documento consolidado a partir de:
- `docs/internal/EXECUTION_PLAN.md`
- `docs/internal/FOOD_DATABASE_PLAN.md`
- `docs/internal/PLAN.md`
- `docs/internal/PLANO_TELAS_MOCKUP.md`
- `docs/internal/SPRINT_PLAN_FINAL.md`
- `docs/internal/UI_PLAN.md`
- estado atual do código em `lib/`

Este passa a ser o checklist final de produto e execução.

## Direção atual do projeto
- manter `Flutter` como frontend principal para `web` e `iPhone`
- manter arquitetura `offline-first`
- usar `Hive` como fonte de verdade local enquanto os fluxos centrais não fecharem
- manter o projeto 100% em `Dart/Flutter`

## Legenda
- `[x]` concluído no código atual
- `[-]` parcialmente pronto / existe base visual ou técnica
- `[ ]` pendente

## 1. Decisão arquitetural final
- [x] manter `Flutter` como stack principal deste app
- [x] priorizar entrega utilizável em `web`
- [x] priorizar compatibilidade prática para uso no `iPhone`
- [x] manter `Hive` local como base do produto
- [x] adiar backend até o fluxo central estar fechado
- [x] manter todo o app em `Dart/Flutter`
- [x] manter UI, navegação, regras, persistência e integrações dentro do ecossistema Flutter

## 2. Base técnica e arquitetura
- [x] `HiveService` inicializado no bootstrap do app
- [x] models principais criados: `CatProfile`, `FoodItem`, `WeightRecord`
- [x] adapters gerados e registrados
- [x] app iniciado com `ProviderScope`
- [x] tema claro/escuro estruturado
- [x] providers base para perfis e gato ativo
- [x] repositório de perfil conectado ao `Hive`
- [x] shell principal com `IndexedStack`
- [-] rotas internas principais ligadas
- [ ] persistência completa de preferências do app
- [ ] padronização final de repositories/providers para todos os fluxos reais

## 3. Design system e componentes reutilizáveis
- [x] `AppCardContainer`
- [x] `CatSelectorAvatar`
- [x] `NeonButton`
- [x] `GhostButton`
- [x] `StatusBadge`
- [x] `DailySummaryRing`
- [x] `VerticalTimelineTile`
- [-] `MealHorizontalCard`
- [ ] skeleton/loading states consistentes
- [ ] empty/error states padronizados

## 4. Navegação principal final
- [x] bottom navigation principal implementada
- [x] FAB central visual no contexto Daily
- [x] abas `Daily` e `Home` apontam para telas reais
- [x] aba `Plans` deixou de usar placeholder
- [x] aba `History` deixou de usar placeholder
- [x] FAB central abre fluxo de scanner
- [ ] revisar todos os pontos de entrada secundários para eliminar ações mortas restantes

## 5. Home
- [x] header com título central e ações
- [x] carrossel horizontal de gatos
- [x] card `Next Feeding`
- [x] card de insights
- [x] grid de stats
- [x] ação `Add New` abrir cadastro real
- [x] seleção de gato refletir estado global
- [x] dados vindos de `Hive/Riverpod`
- [x] empty state coerente sem perfis
- [-] dados ainda parcialmente mockados em blocos da tela
- [ ] remover dados estáticos restantes

## 6. Cat Profile
- [-] tela final aderente ao mock
- [x] formulário completo: nome, peso, idade
- [x] campos para castrado, atividade e objetivo
- [x] seleção de foto
- [x] validação de formulário
- [x] salvar perfil no `Hive`
- [x] editar perfil existente
- [x] excluir perfil
- [x] `ProfileListScreen` existente como base
- [ ] refinamento visual final contra o mock aprovado

## 7. Scanner de alimento
- [x] tela visual inicial
- [x] navegação a partir do FAB e quick actions
- [x] fallback `Manual Entry`
- [x] busca de item existente por barcode na base local mockada/atual
- [x] ação `Confirm Product`
- [ ] overlay alinhado ao mock
- [x] ação de flash
- [x] integração real com câmera
- [x] leitura de barcode multiplataforma
- [x] card inferior final de confirmação

## 8. Daily Dashboard
- [x] header com avatar, saudação e ação lateral
- [x] cards de métricas rápidas
- [x] lista visual de agenda
- [x] CTA visual de scanner
- [x] estrutura conectada ao plano salvo
- [x] marcar refeições como concluídas
- [x] registrar `weight check-in` pelo fluxo diário
- [x] persistir schedule/refeições do dia
- [-] ligar navegação real para scanner e peso em todos os pontos

## 9. Health Dashboard
- [x] app bar visual no estilo do mock
- [x] hero card do gato ativo
- [x] quick actions visuais
- [x] card de resumo diário
- [x] timeline horizontal de refeições
- [-] tela abre a partir da Home com base no gato selecionado
- [ ] conectar resumo diário a dados reais
- [ ] conectar timeline a refeições reais
- [ ] fechar ações rápidas ponta a ponta

## 10. Plans
- [x] tela/fluxo real de `Plans`
- [x] placeholder removido da aba
- [x] cálculo real em `DietCalculatorService`
- [x] exibir meta calórica diária
- [x] exibir porção por refeição
- [x] selecionar gato e alimento de forma completa
- [x] implementar fórmulas `RER/MER`
- [x] validar inputs com limites seguros
- [x] metas de manutenção/perda/ganho
- [x] alertas de saúde por faixa
- [x] persistir plano alimentar atual

## 11. Food Database
- [x] `FoodDatabaseScreen`
- [x] rota registrada
- [x] leitura local via `Hive`
- [x] busca por nome, marca e barcode
- [x] `AddFoodScreen`
- [x] cadastro manual com validação mínima
- [x] salvar `FoodItem` no `Hive`
- [x] integração inicial com `Scanner`
- [x] disponibilizar alimentos para `Plans`
- [-] atualização da lista local validada parcialmente
- [ ] lista de recentes/populares
- [x] persistir alimento escolhido no plano
- [ ] consolidar decisão arquitetural no código, não só na documentação

## 12. Weight Check-in
- [x] tela dedicada de check-in
- [x] exibição do gato selecionado
- [x] valor atual do peso
- [x] controle para ajustar novo peso
- [x] campo de observações
- [x] CTA `Record Weight`
- [x] persistir histórico de peso no `Hive`
- [x] atualizar resumos após salvar
- [ ] revisar acabamento visual final

## 13. History e Weekly Diet Report
- [x] criar tela real de `History`
- [x] substituir placeholder da aba `History`
- [x] estado vazio coerente
- [x] ler `WeightRecord` do `Hive`
- [x] listar registros reais por data
- [x] resumo do último peso
- [x] resumo da variação recente
- [x] tendência simples de evolução
- [x] tela de `Weekly Diet Report`
- [-] gráfico de tendência de peso
- [-] tabela de calorias por dia
- [-] notas veterinárias
- [x] `Download PDF`
- [x] `Share via WhatsApp`
- [x] exportação real em PDF

## 14. Settings
- [x] tela de configurações
- [x] dark mode
- [x] toggle de reminders
- [x] configuração de horários
- [x] idioma
- [x] export JSON
- [x] backup
- [x] persistência local das preferências

## 15. Notificações e rotina
- [ ] solicitar permissões
- [ ] agendar refeições locais
- [ ] payload por gato/refeição
- [ ] snooze
- [ ] repetir amanhã
- [ ] integrar com `Settings`

## 16. Qualidade e fechamento
- [ ] remover placeholders restantes
- [ ] remover dados mockados das telas finais
- [ ] loading/skeleton states consistentes
- [ ] error/empty states consistentes
- [ ] responsividade em telas pequenas
- [ ] revisão visual final contra o mock
- [ ] testes de widget da navegação principal
- [ ] testes do formulário de perfil
- [ ] testes do registro de peso
- [ ] testes de persistência `Hive`

## 17. Roadmap de execução recomendado

### Bloco A: fechar o fluxo central do produto
- [x] fórmulas reais de dieta em `Plans`
- [x] persistência do plano alimentar
- [x] `Daily` conectado ao plano salvo
- [x] refeições do dia com estado real

### Bloco B: fechar entrada operacional de alimentos
- [x] scanner com confirmação real
- [x] câmera
- [x] barcode real
- [ ] itens recentes/populares na base de alimentos

### Bloco C: fechar analytics e compartilhamento
- [ ] gráficos finais
- [x] PDF real
- [x] compartilhamento

### Bloco D: fechar preferências e rotina
- [x] settings persistentes
- [ ] notificações locais
- [x] export/backup

## 18. Ordem imediata recomendada
1. implementar notificações locais integradas a `Settings`
2. finalizar `History / Weekly Report` visualmente
3. revisar `Home` e `Health Dashboard` para remover mocks restantes
3. fechar `Scanner` com confirmação + base local consistente
4. finalizar `History / Weekly Report` com exportação
5. persistir `Settings`
6. implementar notificações
7. revisar testes, responsividade e mocks restantes

## 19. Diagnóstico objetivo do estado atual
- O projeto já passou da fase de mock puro.
- A maior parte do valor pendente está em fluxo real, não em layout.
- `Home`, `Daily`, `Dashboard`, `Settings`, `Food Database`, `Weight Check-in`, `Plans` e `History` já têm base concreta.
- O maior gargalo atual é consolidar cálculo, persistência do plano e execução diária.
- Para este app, `Rust puro` deixaria de ser pragmático por causa do alvo `web + iPhone`.
- A decisão mais consistente é: terminar o produto em `Flutter` e, se ainda fizer sentido depois, extrair um `Rust core` pequeno e bem delimitado.
