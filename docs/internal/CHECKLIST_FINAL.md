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
- [x] provider consolidado de resumo da Home
- [x] dados reais ligados a `Next Feeding`
- [x] dados reais ligados a insights
- [x] mini-gráfico de insights ligado às refeições reais do dia
- [x] dados reais ligados ao grid de stats
- [x] remover dados estáticos restantes

## 6. Cat Profile
- [-] tela final aderente ao mock
- [x] formulário completo: nome, peso, idade
- [x] campos para castrado, atividade e objetivo
- [x] seleção/upload de foto
- [x] validação de formulário
- [x] salvar perfil no `Hive`
- [x] editar perfil existente
- [x] excluir perfil
- [x] `ProfileListScreen` existente como base
- [ ] refinamento visual final contra o mock aprovado

## 6.1 Gestão em lote: grupos e operação para múltiplos gatos
- [x] criar entidade `CatGroup`
- [x] definir limite operacional de gatos no app
- [x] definir limite operacional de grupos no app
- [x] manter perfis individuais separados de grupos
- [x] permitir criar grupo sem exigir detalhes clínicos completos
- [x] criar rota/tela própria para grupo
- [x] permitir criar perfil individual sem depender de grupo
- [x] manter peso, histórico e observações apenas no nível individual do gato
- [x] modelar grupo como unidade operacional própria
- [x] armazenar quantidade de gatos dentro do grupo
- [x] suportar plano aplicado diretamente ao grupo
- [x] adaptar `Daily` para fluxo de grupo sem peso/check-in individual
- [x] exibir resumo operacional básico por grupo
- [ ] validar UX para cenário real de muitos gatos
- [x] definir limites iniciais recomendados:
- [x] até `10` gatos
- [x] até `5` grupos

## 7. Scanner de alimento
- [x] tela visual inicial
- [x] navegação a partir do FAB e quick actions
- [x] fallback `Manual Entry`
- [x] busca de item existente por barcode na base local mockada/atual
- [x] ação `Confirm Product`
- [x] overlay alinhado ao mock
- [x] ação de flash
- [x] integração real com câmera
- [x] leitura de barcode multiplataforma
- [x] card inferior final de confirmação
- [x] scanner persiste apenas dados estruturados do produto
- [x] scanner não salva imagem/frame/foto no `Hive`

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
- [x] conectar resumo diário a dados reais
- [x] conectar timeline a refeições reais
- [x] fechar ações rápidas ponta a ponta

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
- [x] lista de recentes/populares
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
- [x] gráfico de tendência de peso
- [x] tabela de calorias por dia
- [x] notas veterinárias
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
- [x] solicitar permissões
- [x] agendar refeições locais
- [x] payload por gato/refeição
- [x] snooze
- [x] repetir amanhã
- [x] integrar com `Settings`

## 16. Qualidade e fechamento
- [x] remover placeholders restantes
- [x] remover dados mockados das telas finais
- [x] loading/skeleton states consistentes
- [x] empty states consistentes
- [x] error states consistentes
- [x] responsividade em telas pequenas
- [ ] revisão visual final contra o mock
- [x] testes de widget da navegação principal
- [x] testes do formulário de perfil
- [x] testes do registro de peso
- [x] testes de persistência `Hive`

## 17. Roadmap de execução recomendado

### Bloco A: fluxo central já fechado
- [x] fórmulas reais de dieta em `Plans`
- [x] persistência do plano alimentar
- [x] `Daily` conectado ao plano salvo
- [x] refeições do dia com estado real

### Bloco B: entrada operacional de alimentos
- [x] scanner com confirmação real
- [x] câmera
- [x] barcode real
- [x] itens recentes/populares na base de alimentos

### Bloco C: analytics e compartilhamento
- [x] gráficos finais
- [x] PDF real
- [x] compartilhamento

### Bloco D: preferências e rotina
- [x] settings persistentes
- [x] notificações locais
- [x] export/backup

## 18. Prioridade de entrega

### Essencial para entregar
1. validar UX real para cenário de muitos gatos/grupos
2. revisar todos os pontos de entrada secundários para eliminar ações mortas restantes

### Importante, mas não bloqueante
1. `Food Database`
   - consolidar decisão arquitetural no código
2. refinamento visual final
   - `Cat Profile`
   - `Weight Check-in`
   - revisão visual final contra o mock
3. revisão visual final contra o mock

### Polimento técnico
1. `loading/skeleton states` consistentes
2. padronização final de repositories/providers para todos os fluxos reais
3. persistência completa de preferências do app
4. testes críticos
   - navegação principal
   - formulário de perfil
   - registro de peso
   - persistência `Hive`

## 19. Próxima ordem sugerida
1. `Testes`: fluxo crítico e persistência
## 20. Diagnóstico objetivo do estado atual
- O projeto já passou da fase de mock puro.
- A maior parte do valor pendente está em fluxo real, não em layout.
- `Home`, `Daily`, `Dashboard`, `Settings`, `Food Database`, `Weight Check-in`, `Plans` e `History` já têm base concreta.
- O fluxo principal do produto já existe de ponta a ponta.
- O maior volume pendente agora está em polimento, rotina de notificações e robustez.
- Para este app, `Rust puro` deixaria de ser pragmático por causa do alvo `web + iPhone`.
- A decisão mais consistente é: terminar o produto em `Flutter` e, se ainda fizer sentido depois, extrair um `Rust core` pequeno e bem delimitado.
