# Plano de Entrega das Telas (Mockup v1)

## Objetivo
Implementar o conjunto de telas do mockup em Flutter, reaproveitando os componentes já existentes e removendo os placeholders atuais de navegação.

## Escopo das telas
1. Home / CatDiet Planner
2. Cat Profile (edição de perfil)
3. Scanner (barcode/manual entry)
4. Daily Dashboard (agenda do dia)
5. Health Dashboard (resumo diário e timeline)
6. Weekly Diet Report
7. Settings
8. Food Database

## Estado atual (base)
- `DashboardOverviewScreen` já existe e pode ser base para `Health Dashboard`.
- `HomeOverviewScreen` já existe e cobre boa parte da estrutura da Home.
- Navegação principal (`AppShellScreen`) ainda usa telas mock para `Meals`, `Health` e `Profile`.
- Componentes reutilizáveis já disponíveis: cards, botões, timeline, ring progress e avatar selector.

## Plano por fase
### Fase 1: Arquitetura de navegação
- Trocar os mocks do `AppShellScreen` por rotas reais.
- Definir stack de navegação para telas internas (Scanner, Settings, Weekly Report, Food Database).
- Padronizar AppBars e comportamento do FAB por contexto.

Critério de aceite:
- Nenhuma aba principal abre tela placeholder.
- Fluxo entre abas e telas internas funcionando sem quebra de estado.

### Fase 2: Telas core (MVP visual)
- Finalizar Home no layout do mock.
- Implementar Cat Profile (form + toggles + selects).
- Implementar Scanner com overlay e card de confirmação.
- Implementar Daily Dashboard (schedule + weight check-in).

Critério de aceite:
- Estrutura visual aderente ao mock (hierarquia, espaçamento, blocos principais).
- Dados mockados consistentes entre telas.

### Fase 3: Telas analíticas e suporte
- Implementar Health Dashboard (hero do gato + daily summary + meal timeline).
- Implementar Weekly Diet Report (tendência de peso, calorias por dia e notas veterinárias).
- Implementar Food Database (busca + ações rápidas + lista popular).
- Implementar Settings (notificações, tema, idioma, export/backup).

Critério de aceite:
- Todas as 8 telas navegáveis.
- Componentes visuais compartilhados sem duplicação desnecessária.

### Fase 4: Dados reais e qualidade
- Conectar com `HiveService` para perfis, alimentos e registros de peso.
- Persistir configurações de app (tema, reminders, idioma).
- Testes de widget para fluxos críticos e validação de formulário.

Critério de aceite:
- Fechamento/reabertura do app preserva dados principais.
- Testes cobrindo fluxos de cadastro/edição e logging de refeição/peso.

## Mapeamento rápido: tela -> pasta sugerida
- Home: `lib/features/home/`
- Cat Profile: `lib/features/cat_profile/`
- Scanner: `lib/features/scanner/`
- Daily Dashboard: `lib/features/daily/`
- Health Dashboard: `lib/features/dashboard/`
- Weekly Diet Report: `lib/features/reports/`
- Settings: `lib/features/settings/`
- Food Database: `lib/features/food_database/`

## Ordem recomendada de implementação
1. Navegação real (Fase 1)
2. Home + Daily Dashboard + Cat Profile (Fase 2)
3. Scanner + Food Database (Fase 2/3)
4. Health Dashboard + Weekly Report (Fase 3)
5. Settings + persistência + testes (Fase 4)
