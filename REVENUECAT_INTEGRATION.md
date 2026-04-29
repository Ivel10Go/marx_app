RevenueCat Integration — Quick Guide

Overview
- SDK: purchases_flutter + purchases_ui_flutter (installed via `flutter pub add`).
- Entrypoint initialization: `AppBootstrap` initializes RevenueCat with API key `test_PekobyLoTBNwtOUgnVmtfRCAclN`.
- Entitlement ID used in code: `zitate_app_pro`.

Files added
- `lib/core/services/purchases_service.dart` — wrapper around RevenueCat SDK.
- `lib/core/providers/purchases_provider.dart` — Riverpod providers for customer info and pro flag.
- `lib/presentation/paywall/purchase_page.dart` — UI: offerings list, buy, restore, open Customer Center.
- `lib/presentation/paywall/paywall_button.dart` — simple paywall button (can be embedded anywhere).
- Router route: `/purchase` mapped to `PurchasePage` in `lib/core/router/app_router.dart`.

Native setup checklist
- iOS
  - Set `platform :ios, '11.0'` (or newer) in `ios/Podfile`.
  - Enable In-App Purchase capability in Xcode (Target → Capabilities → In-App Purchase).
  - If using Paywalls, ensure `MainActivity` on Android uses `FlutterFragmentActivity`.
- Android
  - Add billing permission in `android/app/src/main/AndroidManifest.xml`:
    `<uses-permission android:name="com.android.vending.BILLING" />`
  - Ensure `launchMode` is `standard` or `singleTop` in the Activity manifest to avoid purchase cancellations.

RevenueCat Dashboard setup (recommended mapping)
1. Create Products in RevenueCat (map to App Store / Play Store product IDs):
   - RevenueCat Product ID: `lifetime` → store product ids e.g. `zitate_lifetime_ios`, `zitate_lifetime_android`
   - RevenueCat Product ID: `yearly` → store product ids e.g. `zitate_yearly_ios`, `zitate_yearly_android`
   - RevenueCat Product ID: `monthly` → store product ids e.g. `zitate_monthly_ios`, `zitate_monthly_android`
2. Create an Offering (e.g. `default`) and include the three products as Packages.
3. Create an Entitlement with ID `zitate_app_pro` and attach the Offering to it.

Testing (Device required)
- iOS: use Sandbox / TestFlight; Android: use Internal Test track + test accounts.
- Test flows:
  - Open `/purchase` page and verify offerings load.
  - Tap a package: simulate purchase. Verify `CustomerInfo` shows entitlement active.
  - Cancel flow: verify no entitlement granted and UI not changed.
  - Restore purchases: tap restore and verify entitlement reactivated when applicable.
  - Paywalls: create a paywall in Dashboard and test `presentPaywallIfNeeded` behavior.

Customer Center
- Customer Center is a RevenueCat Dashboard feature (Pro/Enterprise).
- The app calls `PurchasesService.presentCustomerCenter()` which uses `RevenueCatUI.presentCustomerCenter()`; availability depends on plan/SDK.

Best practices
- Use server-side entitlements for gating features; do not rely solely on local flags.
- Re-fetch `CustomerInfo` after purchases/restores to rely on server-validated status.
- Use `setLogLevel`/debug logs only in development.
- Test on device and use store-provided test accounts and sandbox environments.

Adding UI
- Route `/purchase` is available; add links in your app UI (Settings or Home) to `context.go('/purchase')`.

If you want, I can:
- Add a Settings button that navigates to `/purchase`.
- Add unit/widget tests for the purchase flows (mocking RevenueCat).
- Create example store product ids and a checklist to copy to the RevenueCat dashboard.

Contact me which of the above to add next.