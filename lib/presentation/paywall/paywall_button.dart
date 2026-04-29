import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// no direct purchases types required here

import '../../core/providers/purchases_provider.dart';
import '../../core/services/purchases_service.dart';

class PaywallButton extends ConsumerWidget {
  const PaywallButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.watch(isProProvider);

    return ElevatedButton(
      onPressed: () async {
        if (isPro) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Du bist bereits Zitate App Pro')),
          );
          return;
        }
        final messenger = ScaffoldMessenger.of(context);
        try {
          await PurchasesService.instance.presentPaywallIfNeeded(
            requiredEntitlementId: 'zitate_app_pro',
          );
          // refresh customer info and react if entitlement now active
          final info = await PurchasesService.instance.getCustomerInfo();
          if (PurchasesService.instance.hasProEntitlement(info)) {
            messenger.showSnackBar(
              const SnackBar(
                content: Text('Danke — Zitate App Pro freigeschaltet!'),
              ),
            );
          }
        } catch (e) {
          messenger.showSnackBar(
            SnackBar(content: Text('Fehler beim Kauf: $e')),
          );
        }
      },
      child: const Text('Zitate App Pro freischalten'),
    );
  }
}
