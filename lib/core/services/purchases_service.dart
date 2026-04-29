import 'dart:async';
import 'dart:developer' as developer;

import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

/// Lightweight wrapper around RevenueCat Purchases SDK for the app.
class PurchasesService {
  PurchasesService._();
  static final PurchasesService instance = PurchasesService._();

  final _customerInfoController = StreamController<CustomerInfo>.broadcast();
  Stream<CustomerInfo> get customerInfoStream => _customerInfoController.stream;

  /// Initialize RevenueCat Purchases SDK with given API key.
  Future<void> init(String apiKey, {bool debugLogs = false}) async {
    try {
      await Purchases.setLogLevel(debugLogs ? LogLevel.debug : LogLevel.info);
      await Purchases.configure(PurchasesConfiguration(apiKey));

      // seed initial customer info and listen for updates
      final info = await Purchases.getCustomerInfo();
      _customerInfoController.add(info);

      Purchases.addCustomerInfoUpdateListener((customerInfo) {
        try {
          _customerInfoController.add(customerInfo);
        } catch (e, st) {
          developer.log('Error in customerInfo listener: $e', stackTrace: st);
        }
      });
    } on PurchasesError catch (e) {
      developer.log('Purchases SDK error during init: ${e.message}');
      rethrow;
    } catch (e, st) {
      developer.log(
        'Unexpected error during Purchases init: $e',
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<Offerings?> fetchOfferings() async {
    try {
      return await Purchases.getOfferings();
    } on PurchasesError catch (e) {
      developer.log('Failed to fetch offerings: ${e.message}');
      return null;
    } catch (e, st) {
      developer.log('Failed to fetch offerings: $e', stackTrace: st);
      return null;
    }
  }

  Future<PurchaseResult> purchasePackage(Package pkg) async {
    try {
      final result = await Purchases.purchase(PurchaseParams.package(pkg));
      return result;
    } on PurchasesError catch (e) {
      developer.log('Purchase failed: ${e.message}');
      rethrow;
    } catch (e, st) {
      developer.log('Unexpected purchase error: $e', stackTrace: st);
      rethrow;
    }
  }

  Future<void> restorePurchases() async {
    try {
      await Purchases.restorePurchases();
    } on PurchasesError catch (e) {
      developer.log('Restore failed: ${e.message}');
      rethrow;
    }
  }

  Future<CustomerInfo> getCustomerInfo() => Purchases.getCustomerInfo();

  bool hasProEntitlement(
    CustomerInfo info, {
    String entitlementId = 'zitate_app_pro',
  }) {
    final ent = info.entitlements.all[entitlementId];
    return ent?.isActive ?? false;
  }

  /// Present a RevenueCat Paywall if needed for a required entitlement.
  Future<PaywallResult> presentPaywallIfNeeded({
    String? requiredEntitlementId,
  }) async {
    try {
      if (requiredEntitlementId != null) {
        final result = await RevenueCatUI.presentPaywallIfNeeded(
          requiredEntitlementId,
        );
        return result;
      }

      final result = await RevenueCatUI.presentPaywall();
      return result;
    } catch (e, st) {
      developer.log('Error presenting paywall: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Present the RevenueCat Customer Center (if available for the current plan/SDK).
  /// This will open a native Customer Center UI where supported.
  Future<void> presentCustomerCenter() async {
    try {
      await RevenueCatUI.presentCustomerCenter();
    } catch (e, st) {
      developer.log(
        'Customer Center not available or failed to present: $e',
        stackTrace: st,
      );
      rethrow;
    }
  }

  void dispose() {
    try {
      _customerInfoController.close();
    } catch (_) {}
  }
}
