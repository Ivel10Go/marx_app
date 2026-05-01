import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:purchases_flutter/purchases_flutter.dart'
    show Offerings, Offering, Package;

import '../../core/theme/app_colors.dart';
import '../../core/providers/purchases_provider.dart';
import '../../core/services/purchases_service.dart';

class PurchasePage extends ConsumerStatefulWidget {
  const PurchasePage({super.key});

  @override
  ConsumerState<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends ConsumerState<PurchasePage> {
  Offerings? _offerings;
  bool _loading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    if (!mounted) {
      return;
    }
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final off = await PurchasesService.instance.fetchOfferings();
      if (!mounted) {
        return;
      }
      setState(() {
        _offerings = off;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Angebote konnten nicht geladen werden: $e';
      });
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _buyPackage(Package pkg) async {
    try {
      await PurchasesService.instance.purchasePackage(pkg);
      final info = await PurchasesService.instance.getCustomerInfo();
      if (PurchasesService.instance.hasProEntitlement(info)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Danke — Zitate App Pro freigeschaltet!'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler beim Kauf: $e')));
    }
  }

  Future<void> _restore() async {
    try {
      await PurchasesService.instance.restorePurchases();
      final info = await PurchasesService.instance.getCustomerInfo();
      if (PurchasesService.instance.hasProEntitlement(info)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Käufe wiederhergestellt — Pro aktiv.')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Keine wiederherstellbaren Käufe gefunden.'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Wiederherstellen: $e')),
      );
    }
  }

  Future<void> _openCustomerCenter() async {
    try {
      await PurchasesService.instance.presentCustomerCenter();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Customer Center nicht verfügbar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPro = ref.watch(isProProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Zitate App Pro')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isPro) ...[
                    _PurchaseIntroCard(
                      title: 'Zitate App Pro ist aktiv.',
                      body:
                          'Dein Upgrade ist freigeschaltet und du kannst Käufe jederzeit wiederherstellen.',
                    ),
                    const SizedBox(height: 12),
                  ],
                  _PurchaseIntroCard(
                    title: 'Pro für tiefere Inhalte',
                    body:
                        'Pro soll erweiterte Archive, mehr Kontext und neue Feature-Bundles freischalten. Der freie Kern bleibt dabei voll nutzbar.',
                  ),
                  const SizedBox(height: 12),
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        border: Border.all(color: scheme.outline, width: 1),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loadOfferings,
                      child: const Text('Erneut laden'),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Expanded(
                    child: _offerings == null
                        ? const Center(child: Text('Keine Angebote verfügbar.'))
                        : ListView(
                            children: _offerings!.all.values
                                .map((offering) => _buildOffering(offering))
                                .toList(),
                          ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _restore,
                    child: const Text('Käufe wiederherstellen'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _openCustomerCenter,
                    child: const Text('Customer Center öffnen'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildOffering(Offering offering) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              offering.serverDescription,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            ...offering.availablePackages.map((pkg) {
              final price = pkg.storeProduct.priceString;
              final title = pkg.storeProduct.title;
              return ListTile(
                title: Text(title),
                subtitle: Text(price),
                trailing: ElevatedButton(
                  onPressed: () => _buyPackage(pkg),
                  child: const Text('Kaufen'),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _PurchaseIntroCard extends StatelessWidget {
  const _PurchaseIntroCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'PRO-ANGEBOT',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.red,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              color: scheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
