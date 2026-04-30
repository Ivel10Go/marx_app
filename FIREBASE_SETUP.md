# Firebase Setup Guide

## Overview
This guide covers the complete setup of Firebase in the Marx app, including Crashlytics for crash reporting and performance monitoring.

## Prerequisites
- Firebase account (https://console.firebase.google.com)
- Google Cloud project
- iOS deployment target: 11.0+
- Android minSdkVersion: 21+
- Flutter CLI installed
- Xcode 12.0+ (for iOS)
- Android Studio 4.1+ (for Android)

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add Project"
3. Enter project name: `marx-app`
4. Accept analytics terms (optional but recommended)
5. Select your region
6. Click "Create Project"
7. Wait for project creation to complete

## Step 2: Add Firebase to Flutter Project

### 2.1 Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 2.2 Configure with FlutterFire
```bash
flutterfire configure
```

This command will:
- Guide you through Firebase project selection
- Automatically add necessary dependencies to `pubspec.yaml`
- Generate iOS and Android native configuration files
- Update `lib/firebase_options.dart`

**Select these platforms when prompted:**
- Android
- iOS
- Web (if needed)

### 2.3 Verify Configuration
Check that `pubspec.yaml` includes:
```yaml
dependencies:
  firebase_core: ^latest_version
  firebase_crashlytics: ^latest_version
```

## Step 3: Android Setup

### 3.1 Add Google Services Plugin
`android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
apply plugin: 'com.google.firebase.crashlytics'

dependencies {
    implementation 'com.google.firebase:firebase-analytics'
    implementation 'com.google.firebase:firebase-crashlytics'
}
```

### 3.2 Configure Gradle
`android/build.gradle`:
```gradle
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
        classpath 'com.google.firebase:firebase-crashlytics-gradle:2.9.9'
    }
}
```

### 3.3 Download google-services.json
1. Firebase Console → Project Settings
2. Download `google-services.json` for Android
3. Place in `android/app/`

### 3.4 Verify Android Manifest
`android/app/src/AndroidManifest.xml` should include:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

## Step 4: iOS Setup

### 4.1 Update iOS Deployment Target
`ios/Podfile`:
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'FIREBASE_ANALYTICS_COLLECTION_ENABLED=1'
      ]
    end
  end
end
```

### 4.2 Download GoogleService-Info.plist
1. Firebase Console → Project Settings
2. Download `GoogleService-Info.plist` for iOS
3. Add to Xcode project:
   - Open `ios/Runner.xcworkspace` (NOT Runner.xcodeproj)
   - Right-click "Runner" → "Add Files to Runner"
   - Select `GoogleService-Info.plist`
   - Ensure "Copy items if needed" is checked
   - Add to targets: Runner

### 4.3 Verify iOS Configuration
In Xcode, verify that `GoogleService-Info.plist` appears under:
- Runner → Build Phases → Copy Bundle Resources

## Step 5: Initialize Firebase in main.dart

### 5.1 Update main.dart
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

### 5.2 Enable Crashlytics
```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  
  runApp(const MyApp());
}
```

## Step 6: Crashlytics Configuration

### 6.1 Enable Crashlytics in Firebase Console
1. Firebase Console → Crashlytics
2. Click "Enable Crashlytics"
3. Follow the setup wizard

### 6.2 Test Crashlytics (Android)

Add test button in debug environment:
```dart
ElevatedButton(
  onPressed: () {
    FirebaseCrashlytics.instance.crash();
  },
  child: const Text('Test Crashlytics'),
)
```

### 6.3 Test Crashlytics (iOS)
```dart
ElevatedButton(
  onPressed: () async {
    try {
      throw Exception('Test exception');
    } catch (e, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  },
  child: const Text('Test Crashlytics'),
)
```

## Step 7: Enable Additional Services

### 7.1 Enable Cloud Messaging
For push notifications:
```bash
flutterfire configure
# Select Cloud Messaging
```

### 7.2 Enable Realtime Database
1. Firebase Console → Realtime Database
2. Click "Create Database"
3. Select region
4. Choose "Start in test mode" for development

### 7.3 Enable Firestore
1. Firebase Console → Firestore Database
2. Click "Create database"
3. Start in test mode
4. Select region

## Step 8: Verification Checklist

### 8.1 Build & Run Tests

**Android:**
```bash
flutter run
# Check Android Studio logcat for Firebase initialization messages
```

**iOS:**
```bash
cd ios
pod install
cd ..
flutter run
# Check Xcode console for Firebase initialization
```

### 8.2 Verify Configuration Files
- [ ] `lib/firebase_options.dart` exists and contains proper configuration
- [ ] `android/app/google-services.json` present
- [ ] `ios/Runner/GoogleService-Info.plist` present in Xcode project
- [ ] Firebase initialized in `main.dart`
- [ ] Crashlytics error handlers configured

### 8.3 Monitor in Firebase Console
1. Firebase Console → Analytics
2. Wait 5-10 minutes
3. Should see events flowing in

## Step 9: Production Configuration

### 9.1 Disable Debug Logging
In production builds:
```dart
await FirebaseCrashlytics.instance
    .setCrashlyticsCollectionEnabled(kReleaseMode);
```

### 9.2 Set User Identifier
When user logs in:
```dart
FirebaseCrashlytics.instance.setUserIdentifier(userId);
```

### 9.3 Add Custom Metadata
```dart
FirebaseCrashlytics.instance.setCustomKey('subscription_type', 'premium');
FirebaseCrashlytics.instance.setCustomKey('version', appVersion);
```

## Step 10: Troubleshooting

### Issue: Firebase not initializing
**Solution:**
- Verify internet connection
- Check `google-services.json` and `GoogleService-Info.plist` are correct
- Ensure package names match Firebase project settings
- Run `flutter pub get` and clean build directories

### Issue: Crashes not appearing in Firebase
**Solution:**
- Wait 5-10 minutes for data sync
- Check Crashlytics is enabled in Firebase Console
- Verify app has internet permission
- Use `FirebaseCrashlytics.instance.recordError()` for manual logging

### Issue: Pod install fails on iOS
**Solution:**
```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install --repo-update
cd ..
```

### Issue: Android build fails
**Solution:**
```bash
./gradlew clean
flutter clean
flutter pub get
flutter run
```

## Step 11: Monitoring & Analytics

### 11.1 Set Up Analytics Events
```dart
FirebaseAnalytics.instance.logEvent(
  name: 'premium_purchased',
  parameters: {
    'price': 9.99,
    'currency': 'USD',
  },
);
```

### 11.2 Create Dashboards
1. Firebase Console → Analytics → Dashboard
2. Create custom events dashboard
3. Monitor user behavior and crashes

## References
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev)
- [Firebase Console](https://console.firebase.google.com)
