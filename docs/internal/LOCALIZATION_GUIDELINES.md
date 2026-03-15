# Localization Guidelines

## Idioma Fonte

- Idioma fonte oficial: `en`
- Idiomas suportados em runtime:
  - `en`
  - `pt_BR`
  - `tl`

## Convencao de Chaves

Padrao adotado:
- `...Title`: titulos de secao, dialog e card
- `...Subtitle`: texto secundario curto ligado ao titulo
- `...Description`: explicacao, empty state ou ajuda contextual
- `...Label`: label de campo, metrica ou tag
- `...Action`: CTA de botao
- `...Message`: snackbar, feedback curto e notificacao
- `...Status`: estado operacional
- `...Error`: erro ou validacao

Regras:
- usar `camelCase`
- manter prefixos por dominio quando a chave nao for global
- preferir nomes sem dependencia de layout
- evitar chaves vagas como `title`, `subtitle`, `label`

## Termos Tecnicos em Ingles

Termos mantidos em ingles quando fazem parte do modelo operacional ou sao mais claros assim:
- `kcal`
- `Dashboard`
- `Home`
- `PDF`
- `Tagalog`

## Convencoes de Formato

- `en`:
  - data: formato local do `intl`
  - hora: 12h quando aplicavel
  - decimal: ponto
- `pt_BR`:
  - data: formato local do `intl`
  - hora: 24h
  - decimal: virgula
- `tl`:
  - data: formato local do `intl`
  - hora: 12h
  - decimal: ponto

## Terminologia do Dominio

Nutricao:
- `Daily goal` -> meta diaria de energia
- `Food per day` -> porcao/alimento por dia
- `Portion` -> porcao
- `Serving unit` -> unidade de porcao
- `Meal schedule` -> horario das refeicoes

Clinico:
- `Clinical watch` -> alerta clinico
- `Preventive alert` -> alerta preventivo
- `Appetite` -> apetite
- `Stool` -> fezes/evacuacao conforme contexto
- `Weight trend` -> tendencia de peso

## Processo para Novas Features

1. Criar chave nova primeiro em `app_en.arb`
2. Adicionar descricao quando a chave for ambigua
3. Gerar rascunho de `pt_BR` e `tl`
4. Revisar wording manualmente antes de commitar
5. Evitar traducao automatica em runtime
6. Validar layout em largura pequena e `textScaleFactor` elevado

## Traducao Assistida

- Permitida apenas para rascunho inicial de `pt_BR` e `tl`
- Revisao humana obrigatoria antes de merge
- Nao usar API de traducao em tempo real dentro do app
