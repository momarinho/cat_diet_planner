# Localization Checklist

Checklist para implementar suporte real a multiplos idiomas no app, com base em `Flutter localization`, arquivos `.arb` e traducao revisavel.

## 1. Infraestrutura Base
- [x] adicionar `flutter_localizations` ao projeto
- [x] configurar `intl` e geracao de localizacoes
- [x] criar `l10n.yaml`
- [x] criar pasta `lib/l10n/`
- [x] definir idioma base do projeto

## 2. Idiomas Suportados
- [x] configurar `en` como ingles
- [x] configurar `pt_BR` como portugues do Brasil
- [x] configurar `tl` ou `fil` para Tagalog/Filipino
- [x] registrar `supportedLocales` no `MaterialApp`
- [x] conectar `localizationsDelegates`

## 3. Integracao com Settings
- [x] ligar `Settings.languageCode` ao `MaterialApp.locale`
- [x] garantir troca de idioma em tempo real
- [x] persistir locale selecionado corretamente
- [x] definir fallback quando idioma nao for suportado
- [x] revisar labels da tela de `Settings` para selecao clara de idioma

## 4. Arquivos de Traducao
- [x] criar `app_en.arb`
- [x] criar `app_pt_BR.arb`
- [x] criar `app_tl.arb`
- [x] padronizar nomes de chaves
- [x] adicionar descricoes nas chaves mais ambiguas

## 5. Extracao de Strings
- [x] mapear textos hardcoded no app
- [x] extrair textos de navegacao
- [x] extrair textos de `Dashboard`
- [x] extrair textos de `Plans`
- [x] extrair textos de `Suggestions`
- [x] extrair textos de `Settings`
- [x] extrair textos de dialogs, snackbars e empty states
- [x] extrair textos de erros e validacoes

## 6. Cobertura de Componentes Reutilizaveis
- [x] localizar widgets globais em `core/`
- [x] localizar labels de botoes e formularios reutilizados
- [x] localizar mensagens comuns de confirmacao/cancelamento
- [x] localizar placeholders e helper texts
- [x] localizar textos de cards e modais reutilizados

## 7. Qualidade das Traducoes
- [x] revisar manualmente os textos em ingles
- [x] revisar manualmente os textos em portugues do Brasil
- [x] revisar manualmente os textos em Tagalog/Filipino
- [x] padronizar terminologia do dominio
- [x] revisar tom e clareza em fluxos criticos

## 8. Regras de Conteudo
- [x] definir quando manter termos tecnicos em ingles
- [x] definir convencoes para unidades e datas por idioma
- [x] definir traducao consistente para termos de nutricao
- [x] definir traducao consistente para termos clinicos
- [x] documentar glossario minimo do produto

## 9. Formatacao Localizada
- [x] localizar datas
- [x] localizar horas
- [x] localizar numeros e decimais
- [x] revisar pluralizacao
- [x] revisar interpolacoes com nome do gato, quantidades e unidades

## 10. Fluxos Criticos para Validacao
- [x] onboarding basico
- [x] cadastro/edicao de gato
- [x] criacao e salvamento de plano
- [x] preview e saved plan
- [x] fluxo de sugestoes: gerar, aceitar, adiar, ignorar, reverter
- [x] settings e troca de idioma

## 11. Estrategia de Traducao
- [x] definir idioma fonte para novas chaves
- [x] usar traducao assistida para rascunho inicial
- [x] revisar manualmente antes de commitar
- [x] evitar traducao automatica em runtime
- [x] documentar processo para novas features

## 12. Testes
- [x] teste de troca de locale no app
- [x] teste de persistencia do idioma selecionado
- [x] teste de widgets com textos localizados
- [x] teste de fallback para chave ausente
- [x] revisar overflow de layout em idiomas maiores

## 13. Entrega Recomendada
- [x] Fase 1: infraestrutura + locale funcional no app
- [x] Fase 2: navegacao, `Settings` e textos globais
- [x] Fase 3: `Dashboard`, `Plans` e `Suggestions`
- [x] Fase 4: dialogs, erros, empty states e validacoes
- [x] Fase 5: revisao de qualidade em `en`, `pt_BR` e `tl`
