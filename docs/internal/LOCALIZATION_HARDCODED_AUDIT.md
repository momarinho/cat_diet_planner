# Localization Hardcoded Audit

Status consolidado em `2026-03-15`.

## Hotspots Resolvidos

- `lib/features/plans/`
  - previews, cards, modal inspector, snackbars e validacoes passaram para `l10n`
- `lib/features/suggestions/`
  - cards, dialogs, status, reasons e feedbacks passaram para `l10n`
- `lib/features/settings/`
  - locale selector, dialogs, demo/stress data e feedbacks localizados
- `lib/features/dashboard/`
  - navegação local, hero card, summary e timeline localizados
- `lib/features/daily/`
  - empty states, metricas, sheet de log, badges e auxiliares localizados
- `lib/features/weight/`
  - labels, estados vazios, opções clínicas, notas e snackbars localizados
- `lib/features/cat_profile/`
  - formulario completo, validacoes, dialogs e limites localizados
- `lib/features/scanner/`
  - CTA, mensagens de câmera, estados de lookup e ações localizados
- `lib/features/splash/`
  - CTA e tagline localizados

## Services e Feedback

- `lib/core/localization/app_feedback_localizer.dart`
  - cobre erros localizáveis de plano, porção, sugestão, limite de gatos e imagem inválida
- `lib/core/localization/app_formatters.dart`
  - centraliza data, hora, time slot e decimal por locale

## Residual Esperado

- arquivos gerados em `lib/l10n/app_localizations_*.dart`
- valores de domínio persistidos como códigos internos:
  - `maintenance`
  - `loss`
  - `meal_1`
  - `group_water`
- comentários de código e identificadores técnicos

## Critério Atual

Não há hotspots conhecidos restantes com prioridade de produto para `en`, `pt_BR` e `tl`.
