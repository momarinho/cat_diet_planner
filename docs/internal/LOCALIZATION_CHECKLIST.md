# Localization Checklist

Checklist para implementar suporte real a multiplos idiomas no app, com base em `Flutter localization`, arquivos `.arb` e traducao revisavel.

## 1. Infraestrutura Base
- [ ] adicionar `flutter_localizations` ao projeto
- [ ] configurar `intl` e geracao de localizacoes
- [ ] criar `l10n.yaml`
- [ ] criar pasta `lib/l10n/`
- [ ] definir idioma base do projeto

## 2. Idiomas Suportados
- [ ] configurar `en` como ingles
- [ ] configurar `pt_BR` como portugues do Brasil
- [ ] configurar `tl` ou `fil` para Tagalog/Filipino
- [ ] registrar `supportedLocales` no `MaterialApp`
- [ ] conectar `localizationsDelegates`

## 3. Integracao com Settings
- [ ] ligar `Settings.languageCode` ao `MaterialApp.locale`
- [ ] garantir troca de idioma em tempo real
- [ ] persistir locale selecionado corretamente
- [ ] definir fallback quando idioma nao for suportado
- [ ] revisar labels da tela de `Settings` para selecao clara de idioma

## 4. Arquivos de Traducao
- [ ] criar `app_en.arb`
- [ ] criar `app_pt_BR.arb`
- [ ] criar `app_tl.arb`
- [ ] padronizar nomes de chaves
- [ ] adicionar descricoes nas chaves mais ambiguas

## 5. Extracao de Strings
- [ ] mapear textos hardcoded no app
- [ ] extrair textos de navegacao
- [ ] extrair textos de `Dashboard`
- [ ] extrair textos de `Plans`
- [ ] extrair textos de `Suggestions`
- [ ] extrair textos de `Settings`
- [ ] extrair textos de dialogs, snackbars e empty states
- [ ] extrair textos de erros e validacoes

## 6. Cobertura de Componentes Reutilizaveis
- [ ] localizar widgets globais em `core/`
- [ ] localizar labels de botoes e formularios reutilizados
- [ ] localizar mensagens comuns de confirmacao/cancelamento
- [ ] localizar placeholders e helper texts
- [ ] localizar textos de cards e modais reutilizados

## 7. Qualidade das Traducoes
- [ ] revisar manualmente os textos em ingles
- [ ] revisar manualmente os textos em portugues do Brasil
- [ ] revisar manualmente os textos em Tagalog/Filipino
- [ ] padronizar terminologia do dominio
- [ ] revisar tom e clareza em fluxos criticos

## 8. Regras de Conteudo
- [ ] definir quando manter termos tecnicos em ingles
- [ ] definir convencoes para unidades e datas por idioma
- [ ] definir traducao consistente para termos de nutricao
- [ ] definir traducao consistente para termos clinicos
- [ ] documentar glossario minimo do produto

## 9. Formatacao Localizada
- [ ] localizar datas
- [ ] localizar horas
- [ ] localizar numeros e decimais
- [ ] revisar pluralizacao
- [ ] revisar interpolacoes com nome do gato, quantidades e unidades

## 10. Fluxos Criticos para Validacao
- [ ] onboarding basico
- [ ] cadastro/edicao de gato
- [ ] criacao e salvamento de plano
- [ ] preview e saved plan
- [ ] fluxo de sugestoes: gerar, aceitar, adiar, ignorar, reverter
- [ ] settings e troca de idioma

## 11. Estrategia de Traducao
- [ ] definir idioma fonte para novas chaves
- [ ] usar traducao assistida para rascunho inicial
- [ ] revisar manualmente antes de commitar
- [ ] evitar traducao automatica em runtime
- [ ] documentar processo para novas features

## 12. Testes
- [ ] teste de troca de locale no app
- [ ] teste de persistencia do idioma selecionado
- [ ] teste de widgets com textos localizados
- [ ] teste de fallback para chave ausente
- [ ] revisar overflow de layout em idiomas maiores

## 13. Entrega Recomendada
- [ ] Fase 1: infraestrutura + locale funcional no app
- [ ] Fase 2: navegacao, `Settings` e textos globais
- [ ] Fase 3: `Dashboard`, `Plans` e `Suggestions`
- [ ] Fase 4: dialogs, erros, empty states e validacoes
- [ ] Fase 5: revisao de qualidade em `en`, `pt_BR` e `tl`
