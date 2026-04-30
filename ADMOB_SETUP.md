# AdMob Integration Guide

## Overview
Google AdMob provides a way to monetize your app through banner, interstitial, and rewarded video ads. This guide covers complete setup and integration into Marx app.

## Prerequisites
- Google AdMob account (https://admob.google.com)
- Google Play Developer account
- App Store Developer account (for iOS)
- Flutter CLI
- Xcode 12.0+ (for iOS)
- Android Studio 4.1+ (for Android)

## Phase 1: AdMob Account Setup

### 1.1 Create AdMob Account
1. Visit [Google AdMob](https://admob.google.com)
2. Sign in with Google Account
3. Accept terms and conditions
4. Complete account setup
5. Provide tax information if required

### 1.2 Add Apps to AdMob
1. AdMob Dashboard → Apps → Add App
2. Select platform: Android
3. Enter app name: `Marx`
4. Accept Google Play policies
5. Repeat for iOS

### 1.3 Create Ad Units

**Create these ad units:**

| Type | Format | ID | Name | Placement |
|------|--------|---|----|-----------|
| Banner | 320x50 | `ca-app-pub-xxx...` | Home Banner | Home Screen |
| Interstitial | Full Screen | `ca-app-pub-xxx...` | Course Interstitial | Between Courses |
| Rewarded | Video | `ca-app-pub-xxx...` | Reward Video | Premium Feature |

### 1.4 Get AdMob IDs
1. App Settings → Copy:
   - **App ID** (format: `ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy`)
   - **Ad Unit IDs** for each ad type

2. Store securely in app configuration

### 1.5 Enable Payment Methods
1. Account Settings → Payment Methods
2. Add banking information
3. Set payment threshold
4. Verify account

## Phase 2: iOS Configuration

### 2.1 Update iOS Deployment Target
Xcode:
- Project → Runner → General
- Minimum Deployment Target: iOS 11.0+

### 2.2 Update Info.plist
`ios/Runner/Info.plist`:
```xml
<dict>
    ...
    <key>NSLocalNetworkUsageDescription</key>
    <string>This app uses local network to serve ads</string>
    <key>NSBonjourServices</key>
    <array>
        <string>_http._tcp</string>
        <string>_https._tcp</string>
    </array>
    ...
</dict>
```

### 2.3 Configure App Transport Security
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### 2.4 Verify iOS Capabilities
- Sign in to developer account
- Ensure correct provisioning profile
- Enable necessary capabilities for ads

## Phase 3: Android Configuration

### 3.1 Update AndroidManifest.xml
`android/app/src/AndroidManifest.xml`:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    ...
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <application>
        ...
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
        ...
    </application>
</manifest>
```

### 3.2 Update build.gradle
`android/app/build.gradle`:
```gradle
dependencies {
    implementation 'com.google.android.gms:play-services-ads:22.6.0'
}
```

### 3.3 Sync Gradle
```bash
cd android
./gradlew sync
cd ..
```

## Phase 4: Flutter Integration

### 4.1 Add Google Mobile Ads Package
```bash
flutter pub add google_mobile_ads
```

Verify `pubspec.yaml`:
```yaml
dependencies:
  google_mobile_ads: ^4.0.0
```

### 4.2 Run Flutter Pub Get
```bash
flutter pub get
```

### 4.3 Initialize Mobile Ads
`lib/services/admob_service.dart`:
```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  
  factory AdMobService() => _instance;
  AdMobService._internal();
  
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  
  // Initialize Mobile Ads SDK
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }
  
  // Get Request Configuration
  static RequestConfiguration getRequestConfiguration() {
    return RequestConfiguration(
      keywords: <String>['education', 'learning', 'courses'],
      contentUrl: 'https://www.example.com',
      childDirected: false,
      tagForUnderAgeOfConsent: false,
    );
  }
}
```

### 4.4 Initialize in main.dart
```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'services/admob_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Mobile Ads
  await MobileAds.instance.initialize();
  MobileAds.instance.setRequestConfiguration(
    AdMobService.getRequestConfiguration(),
  );
  
  runApp(const MyApp());
}
```

## Phase 5: Ad Implementation

### 5.1 Banner Ad Implementation
`lib/widgets/banner_ad_widget.dart`:
```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late BannerAd _bannerAd;
  bool _isLoaded = false;
  bool _isLoadingFailed = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdMobService.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() => _isLoadingFailed = true);
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingFailed) {
      return const SizedBox.shrink();
    }
    
    if (!_isLoaded) {
      return const SizedBox(
        height: 50,
        child: CircularProgressIndicator(),
      );
    }

    return SizedBox(
      height: AdSize.banner.height.toDouble(),
      width: AdSize.banner.width.toDouble(),
      child: AdWidget(ad: _bannerAd),
    );
  }
}
```

### 5.2 Interstitial Ad Implementation
`lib/services/interstitial_ad_service.dart`:
```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdService {
  static InterstitialAd? _interstitialAd;

  static Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  static void showInterstitialAd() {
    if (_interstitialAd == null) {
      loadInterstitialAd();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
      },
    );

    _interstitialAd!.show();
  }

  static void dispose() {
    _interstitialAd?.dispose();
  }
}
```

### 5.3 Rewarded Ad Implementation
`lib/services/rewarded_ad_service.dart`:
```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdService {
  static RewardedAd? _rewardedAd;
  static int _rewardAmount = 0;

  static Future<void> loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: AdMobService.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Rewarded ad failed to load: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  static void showRewardedAd(Function(int) onReward) {
    if (_rewardedAd == null) {
      loadRewardedAd();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        _rewardAmount = reward.amount.toInt();
        onReward(_rewardAmount);
      },
    );
  }

  static void dispose() {
    _rewardedAd?.dispose();
  }
}
```

## Phase 6: Ad Placement Strategy

### 6.1 Banner Ads
- **Home Screen**: Sticky bottom banner (non-intrusive)
- **Course List**: Below course cards
- **Settings**: Optional placement
- **Frequency**: Always visible (low CPM but high impression)

### 6.2 Interstitial Ads
- **Between Course Navigation**: After user completes course section
- **Feature Transitions**: Natural breakpoints in app flow
- **Frequency**: Max 2-3 times per session
- **Timing**: Not on app launch, after user action

### 6.3 Rewarded Ads
- **Premium Access**: Unlock premium features
- **Extra Resources**: Download additional materials
- **Bonus Points**: Earn in-app currency
- **Frequency**: User-initiated only

## Phase 7: Using Test Ad Units

### 7.1 Test Ad Unit IDs
Use these for development and testing:

```dart
// Banner
static const String bannerTestAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

// Interstitial
static const String interstitialTestAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

// Rewarded
static const String rewardedTestAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
```

### 7.2 Switch Between Test and Production
```dart
class AdMobService {
  static bool isTestMode = !kReleaseMode;
  
  static String get bannerAdUnitId {
    return isTestMode 
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'YOUR_PRODUCTION_BANNER_ID';
  }
}
```

## Phase 8: Ad Frequency Capping

### 8.1 Implement Frequency Cap
`lib/services/ad_frequency_service.dart`:
```dart
import 'package:shared_preferences/shared_preferences.dart';

class AdFrequencyService {
  static const String lastInterstitialKey = 'last_interstitial_ad';
  static const int minInterstitialInterval = 60; // seconds
  
  static Future<bool> canShowInterstitialAd() async {
    final prefs = await SharedPreferences.getInstance();
    final lastShown = prefs.getInt(lastInterstitialKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
    return (now - lastShown) >= minInterstitialInterval;
  }
  
  static Future<void> recordInterstitialAdShown() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await prefs.setInt(lastInterstitialKey, now);
  }
}
```

### 8.2 Use Frequency Cap
```dart
void showInterstitialIfReady() {
  if (await AdFrequencyService.canShowInterstitialAd()) {
    InterstitialAdService.showInterstitialAd();
    await AdFrequencyService.recordInterstitialAdShown();
  }
}
```

## Phase 9: Production Configuration

### 9.1 Update Ad Unit IDs
Replace test ad unit IDs with production IDs:
```dart
// In AdMobService
static const String bannerAdUnitId = 'ca-app-pub-YOUR_PROD_ID';
static const String interstitialAdUnitId = 'ca-app-pub-YOUR_PROD_ID';
static const String rewardedAdUnitId = 'ca-app-pub-YOUR_PROD_ID';
```

### 9.2 Enable Analytics
```dart
MobileAds.instance.initialize();
// Analytics automatically tracks impressions and clicks
```

### 9.3 Monitor Performance
1. AdMob Dashboard → Performance → Metrics
2. Track revenue per user (RPM)
3. Monitor fill rate
4. Analyze ad performance

## Phase 10: Ad Policy Compliance

### 10.1 Google AdMob Policies
- No clicking ads for yourself
- No incentivizing clicks (except rewarded)
- Must disclose ads to users
- No misleading ad placements
- Respect user experience

### 10.2 Privacy Policy
Update app privacy policy to include:
- Ads served by Google AdMob
- Use of Google's Advertising ID
- Data collection for ad personalization
- User's ability to opt out

### 10.3 Implementation
```dart
// Disable personalized ads (if needed for privacy)
RequestConfiguration(
  tagForUnderAgeOfConsent: true,
);
```

## Phase 11: Troubleshooting

### Issue: Test ads not appearing
**Solution:**
- Verify ad unit IDs are correct
- Check device has internet connection
- Ensure Firebase is properly initialized
- Wait 30 seconds for ad to load
- Check logcat/console for errors

### Issue: No revenue generated
**Solution:**
- Verify production ad unit IDs active
- Check AdMob account approval status
- Ensure sufficient ad impressions (minimum threshold)
- Monitor fill rate
- Wait for payment processing (monthly)

### Issue: Ad serving errors
**Solution:**
- Clear app cache
- Update Google Play Services
- Verify AndroidManifest.xml configuration
- Check network connectivity
- Review AdMob Dashboard for warnings

### Issue: iOS ads not loading
**Solution:**
- Verify Info.plist configuration
- Check iOS deployment target (11.0+)
- Ensure provisioning profile updated
- Review privacy settings in entitlements

## Phase 12: Testing Checklist

- [ ] Test ad units display correctly
- [ ] Banner ads positioned properly
- [ ] Interstitial ads show at right moments
- [ ] Rewarded ads grant rewards
- [ ] No ads shown during loading
- [ ] Frequency cap working
- [ ] No ads in critical user flows
- [ ] Production ad units validated
- [ ] Privacy policy updated
- [ ] Analytics tracking working

## References
- [Google AdMob Documentation](https://support.google.com/admob)
- [Google Mobile Ads SDK for Flutter](https://pub.dev/packages/google_mobile_ads)
- [AdMob Best Practices](https://support.google.com/admob/answer/6001222)
- [AdMob Policies](https://support.google.com/admob/answer/6128543)
