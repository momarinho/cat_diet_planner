# CatDiet Planner

CatDiet Planner e um app Flutter para gerenciar dieta, rotina diaria e peso de multiplos gatos.

O projeto esta sendo construido com foco em:
- Flutter
- Riverpod
- Hive
- arquitetura `offline-first`

## Produto

Especificacao publica do produto:
- [docs/PRODUCT_SPEC.md](docs/PRODUCT_SPEC.md)

Esse documento resume:
- visao do app
- telas alvo
- funcionalidades principais
- decisao atual sobre banco local e backend
- roadmap em alto nivel

## Estrutura de documentacao

Documentacao publica:
- [docs/PRODUCT_SPEC.md](docs/PRODUCT_SPEC.md)

Documentacao interna de execucao:
- `docs/internal/`

## Estrutura de pastas

Padrao atual: `feature-first` com `core` compartilhado e `data` central de persistencia.

```text
lib/
├── core/
│   ├── navigation/
│   ├── theme/
│   └── widgets/
├── data/
│   ├── local/
│   └── models/
├── features/
│   ├── cat_profile/
│   ├── daily/
│   ├── dashboard/
│   ├── food_database/
│   ├── home/
│   ├── scanner/
│   ├── settings/
│   ├── shell/
│   └── weight/
└── main.dart
```

Convencao por feature:
- `screens/` para telas
- `widgets/` para componentes da feature
- `providers/` quando houver estado da feature
- `repositories/` quando houver acesso a dados da feature

## Desenvolvimento

Comandos uteis:

```bash
flutter pub get
flutter run
flutter analyze
./tool/quality_check.sh
```

Para emuladores Android:

```bash
flutter emulators
flutter emulators --launch <emulator_id>
```

## Referencias Flutter

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)
