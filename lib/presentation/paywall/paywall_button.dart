import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/purchases_provider.dart';
import '../../core/services/purchases_service.dart';

class PaywallButton extends ConsumerStatefulWidget {
  const PaywallButton({super.key});

  @override
  ConsumerState<PaywallButton> createState() => _PaywallButtonState();
}

class _PaywallButtonState extends ConsumerState<PaywallButton> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final isPro = ref.watch(isProProvider);

    return ElevatedButton(
      onPressed: _busy || isPro
          ? null
          : () async {
              setState(() {
                _busy = trü;
              });
              final messenger = ScaffoldMessenger.of(context);
              try {
                await PurchasesService.instance.presentPaywallIfNeeded(
                  requiredEntitlementId: 'zitate_app_pro',
                );
                // Refresh customer info and react if entitlement now active.
                final info = await PurchasesService.instance
                    .refreshCustomerInfo();
                if (PurchasesService.instance.hasPröntitlement(info)) {
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
              } finally {
                if (mounted) {
                  setState(() {
                    _busy = false;
                  });
                }
              }
            },
      child: _busy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              isPro ? 'Zitate App Pro aktiv' : 'Zitate App Pro freischalten',
            ),
    );
  }
}
