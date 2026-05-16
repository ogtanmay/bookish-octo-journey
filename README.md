# GrindOS (Flutter)

GrindOS is a futuristic gamified productivity operating system app built with **Flutter + Dart**.

## Stack
- Flutter (Dart)
- Riverpod state management
- Firebase service layer (offline-safe initialization)
- Hive + SQLite offline-first local storage
- Lottie + Rive animation support
- Glassmorphism AMOLED dashboard UI

## Project architecture

```text
lib/
 ├── core/
 ├── screens/
 ├── widgets/
 ├── animations/
 ├── focus_mode/
 ├── gamification/
 ├── ai/
 ├── services/
 ├── models/
 └── utils/
```

## Run locally

```bash
flutter pub get
flutter run
```

## Validate

```bash
flutter analyze
flutter test
```

## Build Android APK

```bash
flutter build apk --release
```

APK output:

`build/app/outputs/flutter-apk/app-release.apk`

## Download link via workflows

Workflow page:

`https://github.com/ogtanmay/bookish-octo-journey/actions/workflows/android-apk.yml`

Latest run page (artifact appears as **grindos-android-apk**):

`https://github.com/ogtanmay/bookish-octo-journey/actions/runs/25953626403`
