import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'supabase_auth_provider.dart';
import '../../core/services/purchases_integration_service.dart';

/// Initializes RevenueCat login/logout reactions to auth state.
final purchasesIntegrationInitializer = Provider<void>((ref) {
  final svc = PurchasesIntegrationService();

  ref.listen(currentSupabaseUserProvider, (previous, next) async {
    final user = next.asData?.value;
    try {
      if (user != null) {
        await svc.logIn(user.id);
      } else {
        await svc.logOut();
      }
    } catch (e) {
      // swallow here; app can log or handle globally
    }
  });

  return;
});
