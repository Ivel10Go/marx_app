import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/user_profile_provider.dart';
import '../services/purchases_service.dart';

/// StreamProvider that emits latest [CustomerInfo] from RevenueCat.
///
/// **Entitlement Sync Mechanism (MON-05)**:
/// - Emits cached snapshot first (fast availability at startup/after-purchase)
/// - Immediately subscribes to the RevenueCat customer info stream for real-time updates
/// - When purchase/restore succeeds, RevenueCat SDK auto-publishes new CustomerInfo
/// - Stream emits → Riverpod rebuilds all watching providers → UI updates without restart
/// - All widgets watching [isProProvider] (PremiumGate, route guards, etc.) update instantly
final customerInfoStreamProvider = StreamProvider((ref) async* {
  final service = PurchasesService.instance;

  final cached = service.latestCustomerInfo;
  if (cached != null) {
    yield cached;
  } else {
    final refreshed = await service.refreshCustomerInfoSafe();
    if (refreshed != null) {
      yield refreshed;
    }
  }

  yield* service.customerInfoStream;
});

/// Simple computed provider that indicates whether the user has the pro entitlement.
///
/// Immediately reflects entitlement changes as RevenueCat updates stream.
/// No stale state: PremiumGate and route guards update on every stream emission.
final isProProvider = Provider<bool>((ref) {
  final debugPremiumOverride =
      kDebugMode && ref.watch(userProfileProvider).premiumTestEnabled;
  if (debugPremiumOverride) {
    return true;
  }

  final async = ref.watch(customerInfoStreamProvider);
  return async.maybeWhen(
    data: (info) => PurchasesService.instance.hasProEntitlement(info),
    orElse: () => false,
  );
});
