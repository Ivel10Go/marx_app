import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/purchase_status.dart';

/// Product IDs for in-app purchases.
abstract final class IapProductIds {
  static const monthlyPremium = 'com.marxapp.premium.monthly';
  static const yearlyPremium = 'com.marxapp.premium.yearly';
  static const godmodeLifetime = 'com.marxapp.godmode.lifetime';

  static const all = <String>[
    monthlyPremium,
    yearlyPremium,
    godmodeLifetime,
  ];
}

/// Service managing in-app purchase state.
/// Uses SharedPreferences to persist purchase state locally.
/// For production, integrate with the `in_app_purchase` Flutter plugin
/// and verify receipts server-side.
class IapService {
  static const _keyPremium = 'iap_premium';
  static const _keyGodmode = 'iap_godmode';
  static const _keyActiveProduct = 'iap_active_product';

  Future<PurchaseState> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final isPremium = prefs.getBool(_keyPremium) ?? false;
    final hasGodmode = prefs.getBool(_keyGodmode) ?? false;
    final activeProductId = prefs.getString(_keyActiveProduct);

    return PurchaseState(
      status: isPremium ? PurchaseStatus.premium : PurchaseStatus.free,
      hasGodmode: hasGodmode,
      activeProductId: activeProductId,
    );
  }

  /// Grant a purchase (called after successful IAP verification).
  Future<PurchaseState> grantPurchase(String productId) async {
    final prefs = await SharedPreferences.getInstance();

    if (productId == IapProductIds.godmodeLifetime) {
      await prefs.setBool(_keyGodmode, true);
      await prefs.setString(_keyActiveProduct, productId);
    } else if (productId == IapProductIds.monthlyPremium ||
        productId == IapProductIds.yearlyPremium) {
      await prefs.setBool(_keyPremium, true);
      await prefs.setString(_keyActiveProduct, productId);
    }

    return loadState();
  }

  /// Revoke premium (e.g., subscription expired or admin reset).
  Future<PurchaseState> revokePremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPremium, false);
    await prefs.remove(_keyActiveProduct);
    return loadState();
  }

  /// Revoke GODMODE (e.g., admin reset).
  Future<PurchaseState> revokeGodmode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyGodmode, false);
    if ((prefs.getString(_keyActiveProduct) ?? '') ==
        IapProductIds.godmodeLifetime) {
      await prefs.remove(_keyActiveProduct);
    }
    return loadState();
  }

  /// Grant premium directly (admin tool).
  Future<PurchaseState> grantPremiumDirect() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPremium, true);
    await prefs.setString(_keyActiveProduct, 'admin_grant');
    return loadState();
  }
}
