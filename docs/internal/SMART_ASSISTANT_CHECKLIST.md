# Smart Assistant Checklist

Checklist para evoluir o app com comportamento mais inteligente e sugestivo, mantendo controle manual e personalizacao.

## 1. Base de decisao
- [x] criar `SuggestionEngine` local/offline
- [x] definir regras v1 (peso, adesao de refeicoes, contexto clinico)
- [x] calcular score de confianca por sugestao
- [x] registrar `reasonCodes` para explicabilidade

## 2. Tipos de sugestao (MVP)
- [x] sugestao de ajuste de kcal diario
- [x] sugestao de ajuste de horarios com base em atraso/adesao
- [x] sugestao de fracionamento de porcao por refeicao
- [x] alerta preventivo para tendencia de peso fora da meta

## 3. UX das sugestoes
- [x] card de sugestao na `Home`
- [x] secao `Sugestoes` em `Plans`
- [x] acoes por sugestao: `Aceitar`, `Adiar`, `Ignorar`
- [x] exibir "por que sugerimos isso" para cada sugestao

## 4. Personalizacao
- [x] nivel de intervencao: `conservador`, `balanceado`, `proativo`
- [x] toggles por categoria de sugestao
- [x] limite de frequencia de sugestoes por dia
- [x] modo `somente alertas` (sem ajustar plano)

## 5. Seguranca e controle
- [x] `autoApply` desativado por padrao
- [x] confirmacao obrigatoria antes de alterar plano
- [x] limites rigidos de ajuste (faixas seguras)
- [x] trilha de auditoria: quem aceitou, quando, e o que mudou

## 6. Persistencia e historico
- [x] salvar sugestoes geradas
- [x] salvar decisao do usuario por sugestao
- [x] historico de impacto (antes/depois)
- [x] acao `reverter ultima mudanca sugerida`

## 7. Qualidade
- [x] testes unitarios do `SuggestionEngine`
- [ ] testes de widget para cards de sugestao
- [ ] teste de fluxo completo: gerar -> aceitar -> aplicar -> reverter
- [ ] teste de stress com muitos gatos/grupos

## 8. Entrega incremental
- [x] Fase 1: engine + 2 sugestoes (kcal e alerta de tendencia)
- [x] Fase 2: UI de sugestoes + personalizacao no `Settings`
- [x] Fase 3: historico de impacto + refinamento de regras
