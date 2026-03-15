# Localization Validation

Fluxos validados para localizacao em `2026-03-15`.

## Cobertura Validada

- inicializacao do app com `en`, `pt_BR` e `tl`
- troca de locale e persistencia do idioma selecionado
- tela de `Settings`
- `Dashboard`
- `Plans`
- `Plan Inspector`
- `Suggestions`
- `Daily`
- `Weight Check-in`
- `Cat Profile`
- `Scanner`
- `Splash`

## Fluxos Criticos

- onboarding basico: app inicia com locale salvo e fallback seguro
- cadastro/edicao de gato: tela validada para renderizacao sob locale suportado
- scanner e splash: telas de entrada e captura validadas com locale ativo
- criacao e salvamento de plano: fluxo validado com locale ativo
- preview e saved plan: cards e modal validados com formato localizado
- sugestoes: gerar, aceitar, adiar, ignorar e reverter validados
- settings e troca de idioma: validados com persistencia

## Critrios Aplicados

- sem excecao de localizacao em runtime
- sem overflow relevante em largura reduzida para componentes testados
- fallback seguro para locale nao suportado
