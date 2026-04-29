import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/purchases_service.dart';

/// StreamProvider that emits latest [CustomerInfo] from RevenueCat.
final customerInfoStreamProvider = StreamProvider((ref) {
  return PurchasesService.instance.customerInfoStream;
});

/// Simple computed provider that indicates whether the user has the pro entitlement.
final isProProvider = Provider<bool>((ref) {
  final async = ref.watch(customerInfoStreamProvider);
  return async.maybeWhen(
    data: (info) => PurchasesService.instance.hasProEntitlement(info),
    orElse: () => false,
  );
});
