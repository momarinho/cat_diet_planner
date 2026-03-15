# DevOps and MLOps Checklist

Checklist para evoluir o projeto com entrega mais confiavel, observabilidade e uma base solida para evolucao do `SuggestionEngine`.

## 1. CI Basico
- [ ] criar pipeline de `CI` para `flutter analyze`
- [ ] criar pipeline de `CI` para `flutter test`
- [ ] falhar merge quando `analyze` ou testes falharem
- [ ] adicionar cache de dependencias `pub`

## 2. Qualidade de Build
- [ ] validar build `apk` em pipeline
- [ ] validar build `web` em pipeline
- [ ] preparar build `aab` para distribuicao interna
- [ ] documentar prerequisitos locais de build

## 3. Release e Distribuicao
- [ ] definir ambientes `dev`, `staging` e `prod`
- [ ] versionar release por tag
- [ ] gerar changelog simples por release
- [ ] preparar distribuicao interna via Firebase App Distribution ou equivalente

## 4. Observabilidade
- [ ] integrar captura de crash (`Crashlytics` ou `Sentry`)
- [ ] padronizar logs para fluxos criticos
- [ ] registrar eventos de produto relevantes
- [ ] documentar politica de logs e privacidade

## 5. Telemetria de Produto
- [ ] evento `plan_saved`
- [ ] evento `suggestion_generated`
- [ ] evento `suggestion_accepted`
- [ ] evento `suggestion_deferred`
- [ ] evento `suggestion_ignored`
- [ ] evento `suggestion_reverted`
- [ ] evento `scanner_product_confirmed`
- [ ] evento `plan_save_failed`

## 6. Base de Dados para Sugestoes
- [ ] salvar dataset estruturado de sugestoes geradas
- [ ] salvar dataset estruturado de decisoes do usuario
- [ ] salvar impacto observado apos mudanca sugerida
- [ ] separar dados anonimizaveis para export

## 7. Avaliacao do SuggestionEngine
- [ ] medir taxa de aceitacao por tipo de sugestao
- [ ] medir taxa de reversao por tipo de sugestao
- [ ] medir aderencia antes/depois de ajustes sugeridos
- [ ] medir impacto em peso apos 7/14 dias
- [ ] criar relatorio simples de qualidade das sugestoes

## 8. MLOps Leve
- [ ] externalizar thresholds e pesos do `SuggestionEngine`
- [ ] versionar regras por arquivo/config
- [ ] permitir comparar versoes de regra
- [ ] documentar como promover uma nova versao de regras

## 9. Export e Analise Offline
- [ ] exportar dataset para `json` ou `csv`
- [ ] criar script para consolidar eventos em dataset de treino/avaliacao
- [ ] documentar esquema dos dados exportados
- [ ] validar anonimização antes de compartilhar dados

## 10. Preparacao para ML Futuro
- [ ] definir features candidatas para modelos futuros
- [ ] definir metrica alvo para score de confianca
- [ ] definir baseline por regras para comparar com modelo
- [ ] preparar pasta para artefatos/versionamento de modelos

## 11. Estrutura de Repositorio
- [ ] criar `docs/devops/` para guias de pipeline e release
- [ ] criar `docs/mlops/` para dataset, features e avaliacao
- [ ] criar `scripts/ml/` para export, treino e avaliacao
- [ ] criar `artifacts/` ou pasta equivalente para configs/modelos versionados

## 12. Entrega Recomendada
- [ ] Fase 1: `CI` + `analyze` + testes
- [ ] Fase 2: builds automatizados + distribuicao interna
- [ ] Fase 3: observabilidade + telemetria de sugestoes
- [ ] Fase 4: dataset estruturado + export offline
- [ ] Fase 5: regras parametrizadas e avaliacao comparativa
- [ ] Fase 6: experimento com modelo simples, se houver dados suficientes
