# CatDiet Planner Product Spec

## Visao do produto
CatDiet Planner e um app Flutter para gerenciar a alimentacao de multiplos gatos com foco em rotina diaria, controle de peso e planejamento alimentar.

Direcao atual:
- `offline-first`
- persistencia local com `Hive`
- arquitetura preparada para sync futuro, sem depender de backend agora

## Objetivo principal
Permitir que a pessoa:
- cadastre e acompanhe gatos
- registre e reutilize alimentos
- monte um plano alimentar
- acompanhe peso e rotina diaria
- gere um historico semanal com tendencia e relatorio

## Stack atual
- Flutter
- Riverpod
- Hive
- `fl_chart`
- rotas nomeadas para fluxos internos

## Telas alvo
### 1. Home
Funcao:
- visao geral do app
- seletor de gatos
- proxima refeicao
- insights rapidos
- cards de saude

Status:
- layout principal existe
- ainda usa dados mockados em partes

### 2. Cat Profile
Funcao:
- criar, editar e excluir perfil do gato
- definir peso, idade, atividade, objetivo e foto

Status:
- existe base de componentes
- fluxo final de formulario ainda nao esta fechado

### 3. Scanner
Funcao:
- capturar barcode
- permitir entrada manual
- confirmar alimento escaneado

Status:
- tela inicial e navegacao prontas
- camera, barcode e persistencia ainda pendentes

### 4. Daily Dashboard
Funcao:
- mostrar agenda do dia
- acompanhar refeicoes
- acessar scanner e check-in de peso

Status:
- layout principal existe
- ainda precisa refletir dados reais

### 5. Health Dashboard
Funcao:
- mostrar o gato ativo
- resumo diario
- timeline de refeicoes
- atalhos para scanner e peso

Status:
- visual principal pronto
- dados reais e fluxos finais ainda pendentes

### 6. Weekly Diet Report
Funcao:
- mostrar tendencia de peso
- mostrar ingestao por dia
- gerar relatorio compartilhavel

Status:
- pendente

### 7. Settings
Funcao:
- tema
- lembretes
- idioma
- exportacao e backup

Status:
- tela e navegacao prontas
- persistencia completa ainda pendente

### 8. Food Database
Funcao:
- listar alimentos
- buscar por nome, marca ou barcode
- cadastrar manualmente
- reaproveitar alimentos no scanner e no plano

Status:
- pendente

### 9. Weight Check-in
Funcao:
- registrar peso atual
- adicionar observacoes
- alimentar historico de peso

Status:
- tela inicial e navegacao prontas
- persistencia ainda pendente

## Funcionalidades principais
### Ja implementado em boa parte
- shell principal com abas
- Home
- Daily
- Health Dashboard
- Settings
- Scanner inicial
- Weight Check-in inicial
- tema claro/escuro
- rotas nomeadas para fluxos internos

### Em andamento
- eliminacao de placeholders restantes
- fechamento dos fluxos reais de scanner e peso
- preparacao da base de alimentos

### Proximas features criticas
- Food Database local com Hive
- Cat Profile real com CRUD
- Plans com calculo alimentar
- History / Weekly Report

## Dados locais
Modelos base ja definidos:
- `CatProfile`
- `FoodItem`
- `WeightRecord`

Fonte de verdade atual:
- `Hive`

Decisao:
- manter local-first
- considerar sync remoto apenas depois dos fluxos centrais estarem fechados localmente

## Backend
Nao entra agora.

Backend so passa a fazer sentido quando o app ja tiver:
- perfis reais
- base de alimentos funcional
- historico de peso persistido
- plano alimentar funcional

Se houver sync futuro:
- preferencia atual: `Supabase`
- motivo: encaixe melhor para backup e sincronizacao relacional

## Roadmap resumido
### Fase 1
- fechar navegacao real
- remover placeholders principais
- fechar Scanner, Settings e Weight Check-in como fluxos iniciais

### Fase 2
- implementar Food Database local
- implementar Cat Profile real
- conectar Home aos dados persistidos

### Fase 3
- implementar Plans e regras de negocio
- conectar Daily e Dashboard aos dados reais

### Fase 4
- implementar History e Weekly Report
- exportacao, backup, notificacoes e acabamento

## Documentacao interna
O planejamento operacional detalhado foi movido para `docs/internal/`.
