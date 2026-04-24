import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/iap_service.dart';
import '../../data/models/purchase_status.dart';

final iapServiceProvider = Provider<IapService>((Ref ref) => IapService());

class IapNotifier extends AsyncNotifier<PurchaseState> {
  @override
  Future<PurchaseState> build() async {
    return ref.read(iapServiceProvider).loadState();
  }

  Future<void> purchase(String productId) async {
    state = const AsyncLoading();
    final result = await ref
        .read(iapServiceProvider)
        .grantPurchase(productId);
    state = AsyncData(result);
  }

  Future<void> revokePremium() async {
    final result = await ref.read(iapServiceProvider).revokePremium();
    state = AsyncData(result);
  }

  Future<void> revokeGodmode() async {
    final result = await ref.read(iapServiceProvider).revokeGodmode();
    state = AsyncData(result);
  }

  Future<void> grantPremiumDirect() async {
    final result = await ref.read(iapServiceProvider).grantPremiumDirect();
    state = AsyncData(result);
  }
}

final iapProvider = AsyncNotifierProvider<IapNotifier, PurchaseState>(
  IapNotifier.new,
);

/// Convenience: is user premium (or has godmode)?
final isPremiumProvider = Provider<bool>((Ref ref) {
  return ref.watch(iapProvider).valueOrNull?.isPremium ?? false;
});
