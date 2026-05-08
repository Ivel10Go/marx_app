# Phase 4: Android Platform Deployment

## Status Summary
- ✅ Flutter app builds on Windows (debug)
- ✅ RevenueCat SDK integrated (test API key: test_PekobyLoTBNwtOUgnVmtfRCAclN)
- ✅ Entitlements provider configured (isProProvider)
- ⏳ Android native build and Play Store setup pending
- ⏸️ iOS deferred for now

## Build Prerequisites

### Windows (Current)
```bash
flutter devices
# Output: Windows (desktop), Chrome, Edge (all available)

# Current build status
flutter analyze  # PASS: 17 info-level warnings (deprecated withOpacity in 7 files)
flutter clean   # Clean cache before platform builds
```

### Android Build Preparation
```bash
# Check Android environment
flutter doctor -v

# Verify:
- [ ] compileSdk >= 34 (current: flutter.compileSdkVersion)
- [ ] Signing key configured (android/app/debug.keystore)
- [ ] App ID matches Google Play Console (currently: com.example.marx_app)

# Build command
flutter build apk --release
flutter build appbundle --release  # For Play Store (preferred)
# Output: build/app/outputs/apk/release/app-release.apk
#         build/app/outputs/bundle/release/app-release.aab
```

## Phase 4.1: Android Google Play Console Setup

### Step 1: Create App Records
1. Go to Google Play Console (https://play.google.com/console)
2. Create new app: "Marx App"
3. Set app category, content rating questionnaire

### Step 2: In-App Product Configuration
1. Go to Monetize > In-app Products
2. Create 2 subscriptions:
   - **Monthly Plan**
     - ID: `com.example.marx_app.zitate_app_pro_monthly_android`
     - Billing Period: 1 month
     - Price: €3.99 (varies by region)
     - Free trial: optional (7 days recommended)

   - **Yearly Plan**
     - ID: `com.example.marx_app.zitate_app_pro_yearly_android`
     - Billing Period: 1 year
     - Price: €29.99
     - Free trial: optional

### Step 3: RevenueCat Dashboard Mapping
1. Go to RevenueCat Dashboard > Production
2. Create Android Offering:
   - Name: `default`
   - Packages:
     - `monthly`: Maps to `com.example.marx_app.zitate_app_pro_monthly_android`
     - `yearly`: Maps to `com.example.marx_app.zitate_app_pro_yearly_android`
   - Entitlement: `zitate_app_pro`

### Step 4: Internal Test Track Setup
1. Go to Testing > Internal Testing
2. Add testers: @example.com accounts for sandbox testing
3. Build APK/AAB and upload to internal track
4. Share internal test link with testers

## Phase 4.2: Build & Upload

### Android Build Process
```bash
# Build for Play Store (AAB format)
flutter build appbundle --release

# Upload to Google Play Console > Internal Testing > Create new release
# File: build/app/outputs/bundle/release/app-release.aab
```

## Testing Checklist

### Android Testing (Internal Track)
- [ ] App installs via internal test link
- [ ] Cold Start < 2 seconds
- [ ] Paywall displays with offerings
- [ ] Sandbox payment processes (no charge)
- [ ] Pro entitlement granted
- [ ] Settings shows "✓ Pro" badge
- [ ] Manage subscription in Play Store → cancel → badge updates
- [ ] Restore purchases works

## Troubleshooting

### Android Issues
- **Products not loading**: Verify app ID matches Google Play Console, check RevenueCat → Android configuration
- **Internal test link doesn't work**: Build APK/AAB, upload to internal track, generate fresh test link
- **Sandbox purchase fails**: Ensure test account is configured in Google Play Console

### iOS Deferred
- iOS setup is intentionally postponed for this release track.
- Re-enable the iOS section only when App Store work starts.

## Next Steps
1. Set up Google Play app
2. Configure Android product IDs in Google Play Console
3. Link RevenueCat Android offering to the Play Store products
4. Build and upload Android AAB to internal track
5. Begin Android payment testing with real test accounts
