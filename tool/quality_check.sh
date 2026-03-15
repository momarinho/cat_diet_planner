#!/usr/bin/env bash
set -euo pipefail

echo "==> flutter analyze"
flutter analyze

echo "==> flutter test"
flutter test

echo "==> quality check passed"
