# CatDiet Planner

CatDiet Planner is a Flutter app for managing feeding plans, daily routines, weight tracking, and operational decisions for individual cats and groups of cats.

The project is built as an `offline-first` application with local persistence, localized UI, and a growing quality/process layer for testing, localization, and future delivery automation.

## Status

Current project focus:
- core product flows implemented
- localization working for `en`, `pt_BR`, and `tl`
- smart suggestions with audit trail, history, and revert flow
- responsive UI being refined for mobile and web
- CI/DevOps planned as the next delivery track

## Core Features

- cat profile creation and editing
- group management
- food database and barcode scanner
- meal plan creation for individual cats and groups
- live plan preview and saved-plan inspector
- daily schedule with logging flow
- weight check-in with clinical context
- smart suggestions with:
  - confirmation before applying
  - safety limits
  - audit trail
  - before/after impact history
  - revert latest suggested change
- local demo and stress scenarios for validation

## Stack

- Flutter
- Riverpod
- Hive
- `intl` + Flutter `l10n`
- `mobile_scanner`
- `flutter_local_notifications`
- `pdf` / `printing`

## Supported Locales

- `en`
- `pt_BR`
- `tl`

Localization uses Flutter `.arb` files and generated `AppLocalizations`.

Useful internal references:
- [LOCALIZATION_CHECKLIST.md](docs/internal/LOCALIZATION_CHECKLIST.md)
- [LOCALIZATION_GUIDELINES.md](docs/internal/LOCALIZATION_GUIDELINES.md)
- [LOCALIZATION_REVIEW.md](docs/internal/LOCALIZATION_REVIEW.md)
- [LOCALIZATION_VALIDATION.md](docs/internal/LOCALIZATION_VALIDATION.md)

## Getting Started

Prerequisites:
- Flutter SDK compatible with `sdk: ^3.11.0`
- Dart SDK bundled with Flutter
- Android Studio, VS Code, or another Flutter-capable IDE

Install dependencies:

```bash
flutter pub get
```

Generate localization files:

```bash
flutter gen-l10n
```

Run the app:

```bash
flutter run
```

Run on web:

```bash
flutter run -d chrome
```

## Quality Commands

Static analysis:

```bash
flutter analyze
```

Run all tests:

```bash
flutter test
```

Run localization-focused tests:

```bash
flutter test test/localization_test.dart
```

Run targeted app quality checks:

```bash
./tool/quality_check.sh
```

## Project Structure

The codebase follows a `feature-first` structure with shared `core` utilities and central `data` persistence.

```text
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── localization/
│   ├── navigation/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── data/
│   ├── local/
│   ├── models/
│   └── repositories/
├── features/
│   ├── cat_group/
│   ├── cat_profile/
│   ├── daily/
│   ├── dashboard/
│   ├── food_database/
│   ├── history/
│   ├── home/
│   ├── plans/
│   ├── scanner/
│   ├── settings/
│   ├── shell/
│   ├── splash/
│   ├── suggestions/
│   └── weight/
├── l10n/
└── main.dart
```

Feature conventions:
- `screens/` for pages
- `widgets/` for feature-specific UI
- `providers/` for state access
- `services/` for domain logic
- `repositories/` for data access
- `models/` for feature-specific models

## Documentation

Public product reference:
- [PRODUCT_SPEC.md](docs/PRODUCT_SPEC.md)

Internal execution and planning docs:
- [SMART_ASSISTANT_CHECKLIST.md](docs/internal/SMART_ASSISTANT_CHECKLIST.md)
- [CHECKLIST_FINAL.md](docs/internal/CHECKLIST_FINAL.md)
- [DEVOPS_MLOPS_CHECKLIST.md](docs/internal/DEVOPS_MLOPS_CHECKLIST.md)
- [LOCALIZATION_CHECKLIST.md](docs/internal/LOCALIZATION_CHECKLIST.md)

## Demo and Stress Validation

The app includes local scenarios for validation and manual QA:
- demo data generation
- stress data generation

These flows are exposed from `Settings` and are useful for:
- validating navigation and persistence
- testing plans and suggestions quickly
- checking high-volume UI behavior

## Current Priorities

- finish responsive review on remaining screens
- introduce pragmatic CI/DevOps
- prepare Firebase Hosting / web delivery flow

## Notes

- This repository is private and not intended for `pub.dev` publication.
- The app is currently designed around local storage, not a live backend.
- Localization and generated files should be kept in sync with `flutter gen-l10n`.
