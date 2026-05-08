import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../core/services/purchases_service.dart';

/// Simple Paywall screen demonstrating Offerings, purchase flow,
/// entitlement check (`zitate_app_pro`) and restore.
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  Offerings? _offerings;
  CustomerInfo? _customerInfo;
  bool _loading = true;

  static const String entitlementId = 'zitate_app_pro';

  @override
  void initState() {
    super.initState();
    _loadOfferings();
    _fetchCustomerInfo();
    Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdated);
  }

  @override
  void dispose() {
    Purchases.removeCustomerInfoUpdateListener(_onCustomerInfoUpdated);
    super.dispose();
  }

  void _onCustomerInfoUpdated(CustomerInfo info) {
    if (!mounted) {
      return;
    }
    setState(() => _customerInfo = info);
  }

  Future<void> _loadOfferings() async {
    if (!mounted) {
      return;
    }
    setState(() => _loading = true);
    try {
      final offer = await Purchases.getOfferings();
      if (!mounted) {
        return;
      }
      setState(() => _offerings = offer);
    } catch (e) {
      if (!mounted) {
        return;
      }
      debugPrint('Error loading offerings: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fehler beim Laden der Angebote')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _fetchCustomerInfo() async {
    try {
      final info = await Purchases.getCustomerInfo();
      if (!mounted) {
        return;
      }
      setState(() => _customerInfo = info);
    } catch (e) {
      debugPrint('Error fetching customer info: $e');
    }
  }

  bool get _isPro {
    final ent = _customerInfo?.entitlements.all[entitlementId];
    return ent?.isActive ?? false;
  }

  Future<void> _purchasePackage(Package package) async {
    setState(() => _loading = true);
    try {
      final result = await PurchasesService.instance.purchasePackage(package);
      final info = result.customerInfo;
      if (!mounted) {
        return;
      }
      setState(() => _customerInfo = info);
      final active = info.entitlements.all[entitlementId]?.isActive ?? false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            active
                ? 'Danke — Pro aktiviert'
                : 'Kauf abgeschlossen, Pro wird gleich aktualisiert',
          ),
        ),
      );
    } on PurchasesError catch (e) {
      if (!mounted) {
        return;
      }
      final message = e.code == PurchasesErrorCode.purchaseCancelledError
          ? 'Kauf abgebrochen — keine Belastung.'
          : 'Fehler beim Kauf: ${e.message}';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) {
        return;
      }
      debugPrint('Unexpected purchase error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unbekannter Fehler beim Kauf')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _restore() async {
    try {
      await Purchases.restorePurchases();
      final info = await Purchases.getCustomerInfo();
      if (!mounted) {
        return;
      }
      setState(() => _customerInfo = info);
      final active = info.entitlements.all[entitlementId]?.isActive ?? false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            active
                ? 'Wiederherstellung erfolgreich'
                : 'Keine aktiven Abos gefunden',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      debugPrint('Restore error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fehler beim Wiederherstellen')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isPro) {
      return const Center(child: Text('Du bist Pro'));
    }
    if (_loading) return const Center(child: CircularProgressIndicator());

    final packages = _offerings?.current?.availablePackages ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Upgrade auf Pro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  if (packages.isEmpty) const Text('Keine Angebote verfügbar'),
                  for (final p in packages)
                    Card(
                      child: ListTile(
                        title: Text(p.packageType.toString()),
                        subtitle: Text(p.storeProduct.priceString),
                        trailing: ElevatedButton(
                          onPressed: () => _purchasePackage(p),
                          child: const Text('Kaufen'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _restore,
                  child: const Text('Käufe wiederherstellen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
