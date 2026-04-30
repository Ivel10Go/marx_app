# RevenueCat Integration Guide

## Overview
RevenueCat simplifies in-app purchase management across iOS and Android. This guide covers setup, configuration, and integration with Marx app.

## Prerequisites
- RevenueCat account (https://www.revenuecat.com)
- Google Play Developer account
- Apple Developer account
- Xcode 12.0+
- Android Studio 4.1+
- Flutter CLI

## Phase 1: RevenueCat Account Setup

### 1.1 Create RevenueCat Account
1. Visit [RevenueCat Dashboard](https://www.revenuecat.com)
2. Sign up with email or GitHub
3. Create organization
4. Agree to terms of service
5. Complete email verification

### 1.2 Create App Project
1. Dashboard → Projects → "Create New Project"
2. Enter app name: `Marx`
3. Select app type: `Mobile`
4. Create project

### 1.3 Get API Keys
1. Project Settings → API Keys
2. Copy:
   - Public API Key (for SDK initialization)
   - Primary API Key (for backend integration)
3. Store securely in environment configuration

## Phase 2: iOS Configuration (StoreKit 2)

### 2.1 Create In-App Purchase Products

**In App Store Connect:**
1. App Store Connect → Your App → "In-App Purchases"
2. Click "Create In-App Purchase"

**Create following subscriptions:**

| Type | Product ID | Name | Price | Duration |
|------|-----------|------|-------|----------|
| Auto-Renewable Subscription | `premium_monthly` | Premium Monthly | $9.99 | Monthly |
| Auto-Renewable Subscription | `premium_yearly` | Premium Yearly | $79.99 | Yearly |
| Consumable | `coins_1000` | 1000 Coins | $9.99 | - |
| Consumable | `coins_5000` | 5000 Coins | $39.99 | - |

### 2.2 Configure Subscription Groups
1. In App Store Connect, go to "Subscription Groups"
2. Create group: `premium_group`
3. Add both premium subscriptions to group

### 2.3 Set Localized Descriptions
For each IAP product:
1. Add description in default language (English)
2. Add screenshot (1242x2208 px)
3. Add pricing details

### 2.4 Enable StoreKit 2
1. Xcode → Project → Runner → Build Settings
2. Search "StoreKit"
3. Set "StoreKit Configuration" to your configuration file

### 2.5 iOS Entitlements
Verify `ios/Runner/Runner.entitlements`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.appleseed</key>
    <true/>
    <key>com.apple.developer.pass-type-identifiers</key>
    <array/>
</dict>
</plist>
```

### 2.6 Link RevenueCat to App Store Connect
1. RevenueCat Dashboard → Products → iOS
2. Click "New iOS Product"
3. Select App Store Connect app
4. Grant access to RevenueCat
5. Products sync automatically

## Phase 3: Google Play Configuration

### 3.1 Create In-App Products in Google Play Console

**Go to Google Play Console:**
1. Your App → Monetization → Products → In-app products
2. Create products matching iOS configuration:

| Type | Product ID | Name | Price |
|------|-----------|------|-------|
| Subscription | `premium_monthly` | Premium Monthly | $9.99 |
| Subscription | `premium_yearly` | Premium Yearly | $79.99 |
| In-app product | `coins_1000` | 1000 Coins | $9.99 |
| In-app product | `coins_5000` | 5000 Coins | $39.99 |

### 3.2 Configure Subscription Groups
1. Monetization → Subscriptions → Subscription Groups
2. Create group: `premium_group`
3. Add both monthly and yearly subscriptions

### 3.3 Link RevenueCat to Google Play
1. RevenueCat Dashboard → Products → Android
2. Select Google Play app
3. Add Service Account JSON key from Google Play Console:
   - Google Play Console → Settings → API access
   - Create new service account
   - Download JSON key
   - Upload to RevenueCat

### 3.4 Enable Billing
In Google Play Console:
1. All apps → Your app → Monetization setup
2. Enable billing
3. Add required information

## Phase 4: Flutter Integration

### 4.1 Add RevenueCat Package
```bash
flutter pub add purchases_flutter
```

Verify `pubspec.yaml`:
```yaml
dependencies:
  purchases_flutter: ^7.0.0
```

### 4.2 Configure Android
`android/app/build.gradle`:
```gradle
dependencies {
    implementation 'com.android.billingclient:billing:7.0.0'
    implementation 'com.revenuecat.purchases:purchases:7.0.0'
}
```

### 4.3 Configure iOS
`ios/Podfile`:
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end
```

Run:
```bash
cd ios && pod install && cd ..
```

### 4.4 Initialize RevenueCat in main.dart
```dart
import 'package:purchases_flutter/purchases_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize RevenueCat
  await Purchases.configure(
    PurchasesConfiguration(
      'REVENUECAT_PUBLIC_API_KEY',
    )..appUserID = 'unique_user_id',
  );
  
  runApp(const MyApp());
}
```

### 4.5 Create RevenueCat Service
`lib/services/purchases_service.dart`:
```dart
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchasesService {
  static final PurchasesService _instance = PurchasesService._internal();
  
  factory PurchasesService() => _instance;
  
  PurchasesService._internal();
  
  // Get available products
  Future<List<StoreProduct>> getAvailableProducts() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current?.availablePackages ?? [];
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }
  
  // Get user subscription status
  Future<CustomerInfo> getCustomerInfo() async {
    return await Purchases.getCustomerInfo();
  }
  
  // Purchase product
  Future<void> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
    } catch (e) {
      print('Purchase failed: $e');
      rethrow;
    }
  }
  
  // Check if user has subscription
  Future<bool> isPremiumUser() async {
    final customerInfo = await Purchases.getCustomerInfo();
    return customerInfo.entitlements.all['premium_entitlement']?.isActive ?? false;
  }
  
  // Restore purchases
  Future<void> restorePurchases() async {
    try {
      await Purchases.restorePurchases();
    } catch (e) {
      print('Restore failed: $e');
      rethrow;
    }
  }
  
  // Set user ID
  Future<void> setUserId(String userId) async {
    await Purchases.logIn(userId);
  }
  
  // Logout
  Future<void> logout() async {
    await Purchases.logOut();
  }
}
```

## Phase 5: Sandbox Testing

### 5.1 iOS Sandbox Testing

**Setup TestFlight Account:**
1. App Store Connect → TestFlight
2. Add tester account (use unique Gmail address)
3. Invite testers to test build

**Test Purchase Flow:**
1. Build and run on test device
2. Go to Settings → App Store
3. Tap Apple ID → View Apple ID → Sandbox Account
4. Login with sandbox tester account
5. Attempt purchase in app

**Clean Sandbox Data:**
1. Settings → Developer → Clear Sandbox Transaction
2. Or logout and re-login

### 5.2 Android Sandbox Testing

**Setup Google Play Tester Account:**
1. Google Play Console → Your App → Testers
2. Add Gmail account to testers
3. Share opt-in link with tester

**Test Purchase Flow:**
1. Install app on device/emulator
2. Device must have Google Play Services
3. Login with tester account
4. Attempt purchase
5. Payment method shows "Google Play Billing"

**Use Test Product IDs:**
RevenueCat provides test product IDs for sandbox:
- `android.test.purchased` (consumable)
- `android.test.canceled` (canceled product)

### 5.3 Test Entitlements

After purchase, verify entitlement:
```dart
final customerInfo = await Purchases.getCustomerInfo();
final isPremium = customerInfo.entitlements.all['premium_entitlement']?.isActive ?? false;
print('Is Premium: $isPremium');
```

## Phase 6: Setup Entitlements

### 6.1 Create Entitlements in RevenueCat
1. Dashboard → Products → Entitlements
2. Create: `premium_entitlement`
3. Link to both subscriptions (monthly & yearly)

### 6.2 Map Products to Entitlements
1. For each subscription product
2. Assign to `premium_entitlement`
3. Save changes

### 6.3 Configure Offering (Product Display)
1. Dashboard → Products → Offerings
2. Create offering: "default"
3. Add available packages:
   - Premium Monthly (subscription)
   - Premium Yearly (subscription)

## Phase 7: Integration Examples

### 7.1 Display Products
```dart
class PremiumUpgradeScreen extends StatefulWidget {
  @override
  State<PremiumUpgradeScreen> createState() => _PremiumUpgradeScreenState();
}

class _PremiumUpgradeScreenState extends State<PremiumUpgradeScreen> {
  late Future<List<StoreProduct>> products;
  
  @override
  void initState() {
    super.initState();
    products = PurchasesService().getAvailableProducts();
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StoreProduct>>(
      future: products,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        
        final packages = snapshot.data!;
        
        return ListView.builder(
          itemCount: packages.length,
          itemBuilder: (context, index) {
            final package = packages[index];
            return _buildProductCard(package);
          },
        );
      },
    );
  }
  
  Widget _buildProductCard(StoreProduct product) {
    return Card(
      child: ListTile(
        title: Text(product.title),
        subtitle: Text(product.description),
        trailing: Text(product.priceString),
        onTap: () => _purchaseProduct(product),
      ),
    );
  }
  
  Future<void> _purchaseProduct(StoreProduct product) async {
    try {
      // Implementation for purchase
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchase failed: $e')),
      );
    }
  }
}
```

### 7.2 Check Subscription Status
```dart
Future<bool> checkPremiumStatus() async {
  final service = PurchasesService();
  return await service.isPremiumUser();
}
```

## Phase 8: Production Checklist

### 8.1 Before App Store Release
- [ ] All products created in App Store Connect
- [ ] StoreKit 2 configuration verified
- [ ] Entitlements configured in RevenueCat
- [ ] iOS certificates and provisioning profiles updated
- [ ] RevenueCat API key secure (not hardcoded)
- [ ] Tested on real device (not simulator)
- [ ] Receipt validation enabled
- [ ] App review guidelines followed

### 8.2 Before Google Play Release
- [ ] All products created in Google Play Console
- [ ] Service account key uploaded to RevenueCat
- [ ] Google Play Billing Library integrated
- [ ] Tested on real device with tester account
- [ ] Billing permission in AndroidManifest.xml
- [ ] Payment methods configured

### 8.3 Backend Integration
- [ ] Setup webhook for subscription events
- [ ] RevenueCat → Firebase Realtime Database sync
- [ ] User subscription status cached
- [ ] Renewal date tracking

## Troubleshooting

### Issue: Products not appearing
**Solution:**
- Verify products created in app store
- Check product IDs match exactly
- Ensure entitlements are linked
- Clear app cache and restart

### Issue: Purchase fails with "BillingClient not ready"
**Solution:**
- Ensure Google Play Services installed
- Verify billing permission in manifest
- Check network connectivity
- Update Google Play Billing Library

### Issue: Sandbox testing not working
**Solution:**
- Verify sandbox tester account active
- Clear app data
- Logout and login with tester account
- Ensure test device has proper configuration

## References
- [RevenueCat Documentation](https://docs.revenuecat.com)
- [App Store Connect Guide](https://developer.apple.com/app-store-connect)
- [Google Play Billing Library](https://developer.android.com/google/play/billing)
- [StoreKit 2 Documentation](https://developer.apple.com/documentation/storekit)
