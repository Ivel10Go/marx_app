# Crashlytics Setup (quick guide)

1. Add dependencies in `pubspec.yaml`:

```yaml
firebase_core: ^2.0.0
firebase_crashlytics: ^3.0.0
```

2. Run `flutterfire configure` and follow prompts.
3. Initialize Crashlytics in `lib/main.dart` before `runApp`.

Example snippet:

```dart
await Firebase.initializeApp();
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
```
