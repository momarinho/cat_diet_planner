# Checklist Final de Entrega

> Obsoleto como fonte principal. Usar `docs/internal/EXECUTION_PLAN.md`.

Documento consolidado a partir de:
- `docs/internal/PLAN.md`
- `docs/internal/PLANO_TELAS_MOCKUP.md`
- `docs/internal/UI_PLAN.md`
- estado atual do código em `lib/`
- conjunto de telas finais aprovado no mock

## Legenda
- `[x]` concluído no código atual
- `[-]` parcialmente pronto / existe base visual, mas falta fluxo real
- `[ ]` pendente

## 1. Base técnica e arquitetura
- [x] `HiveService` inicializado no bootstrap do app
- [x] Models Hive principais criados: `CatProfile`, `FoodItem`, `WeightRecord`
- [x] Adapters gerados e registrados
- [x] App iniciado com `ProviderScope`
- [x] Tema claro/escuro estruturado
- [-] Navegação principal com `AppShellScreen` e `IndexedStack`
- [ ] Rotas internas reais para Scanner, Settings, Weekly Report e Food Database
- [ ] Persistência de configurações do app (tema, idioma, reminders)
- [ ] Providers/repositories conectando UI aos dados reais

## 2. Design system e componentes reutilizáveis
- [x] `AppCardContainer`
- [x] `CatSelectorAvatar`
- [x] `NeonButton`
- [x] `GhostButton`
- [x] `StatusBadge`
- [x] `MealHorizontalCard`
- [x] `DailySummaryRing`
- [x] `VerticalTimelineTile`
- [ ] Skeleton/loading states consistentes
- [ ] Estados de erro e empty state padronizados

## 3. Navegação principal final
Telas do mock final:
- Daily / Dashboard do dia
- Home
- Plans
- History

Checklist:
- [x] Bottom navigation principal implementada
- [x] FAB central estilo scanner no contexto Daily
- [-] Abas Daily e Home apontam para telas reais
- [ ] Aba Plans deixar de usar placeholder
- [ ] Aba History deixar de usar placeholder
- [ ] FAB central abrir fluxo real de scanner

## 4. Tela 1: Home / CatDiet Planner
Referência visual: primeira tela do mock final.

- [x] Header com título central e ações
- [x] Carrossel horizontal de gatos
- [x] Card "Next Feeding"
- [x] Card de health insights
- [x] Grid de stats inferiores
- [-] Dados ainda mockados nesta tela
- [ ] Ação "Add New" abrir fluxo real de cadastro
- [ ] Seleção de gato refletir estado global do gato ativo
- [ ] Dados vindos de Hive/Riverpod

## 5. Tela 2: Cat Profile
Referência visual: tela de edição de perfil com foto, campos, toggles e selects.

- [ ] Tela final de edição aderente ao mock
- [ ] Formulário completo: nome, peso, idade
- [ ] Campos para castrado/esterilizado, atividade e objetivo de dieta
- [ ] Upload/seleção de foto
- [ ] Validação de formulário
- [ ] Salvar perfil no Hive
- [ ] Fluxo de editar perfil existente
- [ ] Fluxo de excluir perfil

Observação:
- [x] Existe base de tela em `ProfileListScreen`
- [-] Tela atual funciona mais como showcase de componentes do que fluxo final de perfil

## 6. Tela 3: Scanner de alimento
Referência visual: tela full-screen com overlay de barcode e card de confirmação.

- [ ] Tela visual do scanner
- [ ] Overlay de leitura alinhado ao mock
- [ ] Ação de flash
- [ ] Integração com câmera
- [ ] Leitura de barcode via ML Kit
- [ ] Fallback "Manual Entry"
- [ ] Card inferior com alimento detectado
- [ ] Ação "Confirm Product"
- [ ] Navegação a partir do FAB e quick actions

## 7. Tela 4: Daily Dashboard
Referência visual: tela "Today's Schedule" / "Good morning".

- [x] Header com avatar, saudação e ação lateral
- [x] Cards de métricas rápidas
- [x] Lista vertical de agenda
- [x] CTA visual de scanner no rodapé
- [-] Estrutura visual próxima do mock, mas ainda com dados estáticos
- [ ] Marcar refeições como concluídas
- [ ] Registrar weight check-in
- [ ] Persistir schedule/refeições do dia
- [ ] Navegar para scanner e peso por ações reais

## 8. Tela 5: Health Dashboard do gato
Referência visual: tela com hero do gato, quick actions, daily summary e meal timeline.

- [x] AppBar visual no estilo do mock
- [x] Hero card do gato ativo
- [x] Quick actions de scanner e log weight
- [x] Card de resumo diário
- [x] Timeline horizontal de refeições
- [-] Tela aberta a partir da Home com dados do gato selecionado
- [ ] Conectar resumo diário a dados reais
- [ ] Conectar timeline a refeições reais
- [ ] Ações rápidas abrirem fluxos reais

## 9. Tela 6: Weekly Diet Report
Referência visual: tela de relatório semanal com tendência de peso, tabela calórica e notas veterinárias.

- [ ] Tela do relatório semanal
- [ ] Gráfico de tendência de peso
- [ ] Tabela de calorias por dia
- [ ] Card de notas veterinárias
- [ ] Ação "Download PDF"
- [ ] Ação "Share via WhatsApp"
- [ ] Exportação real em PDF

## 10. Tela 7: Weight Check-in
Referência visual: tela de registro de peso com valor atual, slider/gráfico e CTA.

- [ ] Tela dedicada de check-in de peso
- [ ] Exibição do gato selecionado
- [ ] Valor atual do peso
- [ ] Controle para ajustar novo peso
- [ ] Campo de observações
- [ ] CTA "Record Weight"
- [ ] Persistir histórico de peso no Hive
- [ ] Atualizar gráficos e resumos após salvar

## 11. Tela 8: Settings
Referência visual: tela com reminders, theme, idioma, export e backup.

- [ ] Tela de configurações
- [ ] Toggle de meal reminders
- [ ] Configuração de horário/agenda
- [ ] Toggle de dark mode
- [ ] Seleção de idioma
- [ ] Exportar para JSON
- [ ] Backup de dados
- [ ] Persistência local das preferências

## 12. Tela 9: Food Database
Referência visual: busca, scan barcode, add manually e lista de alimentos.

- [ ] Tela de Food Database
- [ ] Busca por nome/marca/tipo
- [ ] Atalho "Scan Barcode"
- [ ] Atalho "Add Manually"
- [ ] Lista "Recently Used & Popular"
- [ ] Salvar alimentos no Hive
- [ ] Reaproveitar itens no cálculo/plano

## 13. Regras de negócio e dados reais
- [ ] Implementar `DietCalculatorService`
- [ ] Fórmulas RER/MER validadas
- [ ] Inputs com limites seguros
- [ ] Cálculo de porção por refeição
- [ ] Meta de manutenção/perda/ganho
- [ ] Comparação com histórico de peso
- [ ] Alertas de saúde por faixa de peso/IMC
- [ ] Salvar plano alimentar atual

## 14. Notificações e rotina
- [ ] Solicitar permissões
- [ ] Agendar refeições locais
- [ ] Payload por gato/refeição
- [ ] Snooze
- [ ] Repetir amanhã
- [ ] Fluxo configurável via Settings

## 15. Qualidade e fechamento
- [ ] Remover placeholders restantes
- [ ] Remover dados mockados das telas finais
- [ ] Garantir responsividade em telas pequenas
- [ ] Revisar consistência visual com o mock final
- [ ] Testes de widget para navegação principal
- [ ] Testes de formulário de perfil
- [ ] Testes para registro de peso
- [ ] Testes para persistência Hive

## 16. Prioridade final recomendada
### Bloco A: fechar navegação real
- [ ] Scanner
- [ ] Settings
- [ ] Food Database
- [ ] Weight Check-in

### Bloco B: substituir placeholders da shell
- [ ] Plans
- [ ] History / Weekly Report

### Bloco C: conectar dados reais
- [ ] gato ativo global
- [ ] perfis no Hive
- [ ] refeições do dia
- [ ] histórico de peso
- [ ] preferências do app

### Bloco D: acabamento
- [ ] PDF / share
- [ ] notificações
- [ ] testes críticos

## 17. Diagnóstico objetivo do estado atual
- O projeto já tem a base visual principal do design system.
- Home, Daily Overview e Health Dashboard já existem em nível de mock funcional.
- A navegação principal existe, mas ainda não representa o conjunto final completo.
- As lacunas principais estão em fluxos reais, persistência integrada e nas telas finais ainda ausentes.
- O próximo marco lógico é sair de "mock navegável" para "produto navegável com dados reais".
