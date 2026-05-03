import 'dart:async';
import 'dart:developer' as developer;

import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class OfferingsFetchResult {
  const OfferingsFetchResult({
    required this.offerings,
    required this.attempts,
    required this.isTimeout,
    this.errorMessage,
  });

  final Offerings? offerings;
  final int attempts;
  final bool isTimeout;
  final String? errorMessage;

  bool get hasOfferings => offerings != null;
}

/// Lightweight wrapper around RevenueCat Purchases SDK for the app.
class PurchasesService {
  PurchasesService._();
  static final PurchasesService instance = PurchasesService._();

  final _customerInfoController = StreamController<CustomerInfo>.broadcast();
  CustomerInfo? _latestCustomerInfo;
  bool _initialized = false;
  bool _customerInfoListenerAdded = false;

  CustomerInfo? get latestCustomerInfo => _latestCustomerInfo;
  Stream<CustomerInfo> get customerInfoStream => _customerInfoController.stream;

  void _publishCustomerInfo(CustomerInfo customerInfo) {
    _latestCustomerInfo = customerInfo;
    try {
      _customerInfoController.add(customerInfo);
    } catch (e, st) {
      developer.log('Error publishing customer info: $e', stackTrace: st);
    }
  }

  /// Initialize RevenueCat Purchases SDK with given API key.
  Future<void> init(String apiKey, {bool debugLogs = false}) async {
    if (_initialized) {
      return;
    }

    try {
      await Purchases.setLogLevel(debugLogs ? LogLevel.debug : LogLevel.info);
      await Purchases.configure(PurchasesConfiguration(apiKey));

      // seed initial customer info and listen for updates
      final info = await Purchases.getCustomerInfo();
      _publishCustomerInfo(info);

      if (!_customerInfoListenerAdded) {
        Purchases.addCustomerInfoUpdateListener((customerInfo) {
          _publishCustomerInfo(customerInfo);
        });
        _customerInfoListenerAdded = true;
      }

      _initialized = true;
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

  Future<OfferingsFetchResult> fetchOfferingsWithStatus({
    int maxAttempts = 2,
    Duration timeout = const Duration(seconds: 8),
  }) async {
    Object? lastError;
    bool timedOut = false;

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final offerings = await Purchases.getOfferings().timeout(timeout);
        return OfferingsFetchResult(
          offerings: offerings,
          attempts: attempt,
          isTimeout: false,
        );
      } on TimeoutException {
        timedOut = true;
        lastError = 'Zeitüberschreitung beim Laden der Angebote';
        developer.log(
          'Offerings fetch timed out (attempt $attempt/$maxAttempts)',
        );
      } on PurchasesError catch (e) {
        lastError = e.message;
        developer.log(
          'Failed to fetch offerings (attempt $attempt/$maxAttempts): ${e.message}',
        );
      } catch (e, st) {
        lastError = e;
        developer.log(
          'Failed to fetch offerings (attempt $attempt/$maxAttempts): $e',
          stackTrace: st,
        );
      }
    }

    return OfferingsFetchResult(
      offerings: null,
      attempts: maxAttempts,
      isTimeout: timedOut,
      errorMessage: lastError?.toString(),
    );
  }

  Future<Offerings?> fetchOfferings() async {
    final result = await fetchOfferingsWithStatus();
    return result.offerings;
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

  /// Refresh customer info from RevenueCat and push it to listeners.
  Future<CustomerInfo> refreshCustomerInfo() async {
    final info = await Purchases.getCustomerInfo();
    _publishCustomerInfo(info);
    return info;
  }

  Future<CustomerInfo?> refreshCustomerInfoSafe() async {
    try {
      return await refreshCustomerInfo();
    } on PurchasesError catch (e) {
      developer.log('Customer info refresh failed: ${e.message}');
      return null;
    } catch (e, st) {
      developer.log('Customer info refresh failed: $e', stackTrace: st);
      return null;
    }
  }

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
