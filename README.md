# GrindOS

GrindOS is a futuristic productivity operating system style app built with React + Vite and packaged for Android with Capacitor.

## Local development

```bash
npm install
npm run dev
```

## Build web app

```bash
npm run build
```

## Build Android debug APK locally

```bash
npm run android:apk
```

APK output:

`android/app/build/outputs/apk/debug/app-debug.apk`

## Download APK from GitHub Actions workflow

1. Open **Actions** tab in this repository.
2. Run **Build Android APK** workflow (or wait for it on push to `main`).
3. Open the workflow run.
4. Download artifact **grindos-android-apk**.

Direct workflow page:

`https://github.com/ogtanmay/bookish-octo-journey/actions/workflows/android-apk.yml`
