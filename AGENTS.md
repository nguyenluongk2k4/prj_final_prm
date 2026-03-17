# Repository Guidelines

## Project Structure & Module Organization
- `lib/` holds Flutter source. `lib/core/` (DI, network, errors, theme, router), `lib/features/` (feature modules with domain/data/presentation), `lib/i18n/` (Slang translations), `lib/gen/` (generated assets).
- `assets/` stores images, icons, animations, and fonts.
- `test/` contains Flutter tests (currently `widget_test.dart`).
- `android/`, `ios/`, `web/` are platform shells.
- `supabase/migrations/` contains SQL schema changes.
- `build/` and `.dart_tool/` are generated.

## Build, Test, and Development Commands
- `fvm flutter pub get` installs dependencies (use `flutter pub get` if not using FVM).
- `dart run build_runner build --delete-conflicting-outputs` generates MobX/Freezed/JSON/DI code.
- `dart run slang` regenerates i18n files from `slang.yaml`.
- `fvm flutter run` launches the app.
- `flutter test` runs unit and widget tests.
- `flutter analyze` runs static analysis using `analysis_options.yaml`.

## Coding Style & Naming Conventions
- Follow Dart/Flutter formatting (`dart format .`) and lints from `analysis_options.yaml` (Flutter lints).
- File names use `snake_case.dart`; classes use `PascalCase`; variables and functions use `lowerCamelCase`.
- Use trailing commas to keep widget trees and collections formatted.
- Do not edit generated files (`*.g.dart`, `*.freezed.dart`, `lib/gen/`).

## Testing Guidelines
- Use `flutter_test`.
- Place tests under `test/` and name files `*_test.dart`.
- Add or update tests for new feature logic and critical UI flows.

## Commit & Pull Request Guidelines
- Existing history uses short, lowercase summaries without strict prefixes (for example: "add swipe", "update auth", "fix noti, chat").
- New commits should keep that brevity but be descriptive; avoid placeholders like "a".
- PRs should include a short summary, testing notes (commands + results), and screenshots for UI changes.

## Security & Configuration Tips
- `.env` is required for Supabase, Firebase, Mapbox, and Tencent keys and is git-ignored.
- Configuration steps live in `README_SETUP.md`. Update it when adding new services or env vars.
