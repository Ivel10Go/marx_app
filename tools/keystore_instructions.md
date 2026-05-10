# Android Keystore & Signing Instructions

1. Generate keystore (if not existing):

```bash
keytool -genkey -v -keystore release.keystore -alias marx_release -keyalg RSA -keysize 2048 -validity 10000
```

2. Place `release.keystore` under `android/app/` and configure `android/app/build.gradle.kts` signingConfigs.

3. Update `local.properties` or CI secrets to provide keystore password and alias.

4. Build release AAB:

```bash
flutter build appbundle --release
```
