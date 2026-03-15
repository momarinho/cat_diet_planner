# CatDiet Planner Product Spec

## Visao do produto
CatDiet Planner e um app Flutter para gerenciar alimentacao, rotina diaria e acompanhamento de peso de multiplos gatos.

Direcao atual:
- `offline-first`
- persistencia local com `Hive`
- arquitetura preparada para evolucao futura de sync

## Objetivo principal
Permitir que a pessoa:
- cadastre e acompanhe gatos individuais e grupos
- registre e reutilize alimentos
- monte e mantenha planos alimentares personalizados
- execute rotina operacional diaria
- acompanhe peso e indicadores clinicos
- gere relatorios em PDF e compartilhe

## Stack atual
- Flutter
- Riverpod
- Hive
- `mobile_scanner`
- `pdf` + `printing` + `share_plus`
- notificacoes locais (`flutter_local_notifications`)

## Estado atual por modulo

### 1. Home
Status: **concluido**
- seletor de gato/grupo ativo
- proximas refeicoes e insights conectados a dados reais
- cards e estatisticas sem placeholder

### 2. Cat Profile
Status: **concluido**
- CRUD completo de perfil
- dados clinicos estruturados
- foto, metas e alertas de peso

### 3. Groups
Status: **concluido**
- grupo operacional com vinculo a gatos reais
- categorias/subgrupos e notas por turno/ambiente
- plano aplicado em nivel de grupo

### 4. Scanner
Status: **concluido**
- leitura de barcode multiplataforma
- confirmacao de produto existente
- fallback para cadastro manual
- persistencia apenas de dados estruturados do alimento

### 5. Daily
Status: **concluido**
- agenda real de refeicoes por gato/grupo
- log operacional (atraso, recusa, reduzido, agua, petiscos, suplementos)
- duplicar rotina de ontem para hoje

### 6. Plans
Status: **concluido**
- calculo real de dieta (`RER/MER`)
- nomes/horarios/porcoes por refeicao
- multiplos planos por gato com selecao de plano ativo
- plano por dia da semana e alternativa de fim de semana
- suporte a mais de um alimento no mesmo plano

### 7. Food Database
Status: **concluido (arquitetura consolidada)**
- cadastro manual completo
- busca por nome, marca, tags e barcode
- recentes/populares
- reuso direto em scanner e plans
- fluxo padronizado com repositorio/provider

### 8. Weight Check-in
Status: **concluido**
- check-in com data/hora manual
- contexto do peso e sinais clinicos (apetite/fezes/vomito/energia)
- nota clinica estruturada
- alertas customizaveis

### 9. History e Weekly Diet Report
Status: **concluido**
- historico de peso por gato
- rastreabilidade explicita por `catId` em `WeightRecord`
- relatorio semanal com range customizado, PDF configuravel e compartilhamento

### 10. Settings
Status: **concluido**
- tema, idioma, notificacoes, quiet hours, perfis de notificacao
- export/backup JSON
- pagina `How the app works`
- geracao de cenarios demo e stress

## Qualidade atual
- `flutter analyze` sem issues
- suite de testes passando em execucao completa
- comando unico de qualidade: `./tool/quality_check.sh`
- smoke test de rotas internas principais
- teste de stress UX para Home + Daily com carga alta de gatos/grupos

## Pendencias prioritarias atuais
1. ampliar cobertura de testes para cenarios de rotina diaria e relatorios semanais
2. evoluir telemetria de uso local para apoiar ajustes finos de UX
3. priorizar evolucoes operacionais da Fase 5 (auditoria diaria e alertas inteligentes)

## Backend
Nao e prioridade nesta fase.

Direcao:
- finalizar produto local-first em Flutter
- considerar sync remoto apenas apos fechamento total do fluxo operacional
