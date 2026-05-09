import 'package:purchases_flutter/purchases_flutter.dart';

/// Lightweight wrapper around RevenueCat (purchases_flutter)
class PurchasesIntegrationService {
  PurchasesIntegrationService._();
  static final PurchasesIntegrationService _instance =
      PurchasesIntegrationService._();
  factory PurchasesIntegrationService() => _instance;

  /// Log in RevenueCat with app user id
  Future<void> logIn(String userId) async {
    try {
      await Purchases.logIn(userId);
    } catch (e) {
      // bubble up or log as needed
      rethrow;
    }
  }

  /// Log out RevenueCat
  Future<void> logOut() async {
    try {
      await Purchases.logOut();
    } catch (e) {
      rethrow;
    }
  }
}
