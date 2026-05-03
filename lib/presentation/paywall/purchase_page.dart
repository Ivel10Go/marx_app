import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:purchases_flutter/purchases_flutter.dart'
    show Offerings, Offering, Package, PurchasesError, PurchasesErrorCode;

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
  bool _purchaseBusy = false;
  bool _restoreBusy = false;
  bool _customerCenterBusy = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _refreshEntitlementSnapshot();
    _loadOfferings();
  }

  Future<void> _refreshEntitlementSnapshot() async {
    await PurchasesService.instance.refreshCustomerInfoSafe();
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
      final result = await PurchasesService.instance.fetchOfferingsWithStatus();
      final off = result.offerings;
      final hasPackages =
          off != null &&
          off.all.values.any(
            (offering) => offering.availablePackages.isNotEmpty,
          );

      if (!mounted) {
        return;
      }
      setState(() {
        _offerings = off;
        if (off == null) {
          _errorMessage = result.isTimeout
              ? 'Angebote konnten nicht rechtzeitig geladen werden. Bitte erneut versuchen.'
              : 'Angebote konnten nicht geladen werden. Bitte Verbindung und RevenueCat-Setup prüfen.';
        } else if (!hasPackages) {
          _errorMessage =
              'Angebote geladen, aber ohne kaufbare Pakete. Bitte Offering-Konfiguration prüfen.';
        } else {
          _errorMessage = null;
        }
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
    if (_purchaseBusy) {
      return;
    }
    setState(() {
      _purchaseBusy = true;
    });
    try {
      await PurchasesService.instance.purchasePackage(pkg);
      final info = await PurchasesService.instance.refreshCustomerInfo();
      if (PurchasesService.instance.hasProEntitlement(info)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Danke — Zitate App Pro ist nun aktiv! 🎉'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Kauf verarbeitet. Pro-Status wird noch aktualisiert — bitte gedulde dich einen Moment.',
            ),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } on PurchasesError catch (e) {
      if (!mounted) return;
      final cancelled = e.code == PurchasesErrorCode.purchaseCancelledError;
      final networkError = e.code == PurchasesErrorCode.networkError;
      final message = cancelled
          ? 'Kauf abgebrochen — keine Belastung.'
          : networkError
          ? 'Netzwerkfehler beim Kauf. Bitte Verbindung überprüfen und erneut versuchen.'
          : 'Kauf nicht abgeschlossen: ${e.message} — Bitte erneut versuchen.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 5)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Kauf: $e — Bitte erneut versuchen.'),
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _purchaseBusy = false;
        });
      }
    }
  }

  Future<void> _restore() async {
    if (_restoreBusy) {
      return;
    }
    setState(() {
      _restoreBusy = true;
    });
    try {
      await PurchasesService.instance.restorePurchases();
      final info = await PurchasesService.instance.refreshCustomerInfo();
      if (PurchasesService.instance.hasProEntitlement(info)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Käufe wiederhergestellt — Pro ist aktiv!'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Keine aktiven Käufe auf diesem Gerät gefunden.'),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } on PurchasesError catch (e) {
      if (!mounted) return;
      final networkError = e.code == PurchasesErrorCode.networkError;
      final message = networkError
          ? 'Netzwerkfehler beim Wiederherstellen. Bitte Verbindung überprüfen.'
          : 'Wiederherstellung fehlgeschlagen: ${e.message} — Bitte erneut versuchen.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 5)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Fehler beim Wiederherstellen: $e — Bitte erneut versuchen.',
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _restoreBusy = false;
        });
      }
    }
  }

  Future<void> _openCustomerCenter() async {
    if (_customerCenterBusy) {
      return;
    }
    setState(() {
      _customerCenterBusy = true;
    });
    try {
      await PurchasesService.instance.presentCustomerCenter();
    } catch (e) {
      if (!mounted) return;
      // Customer Center nicht verfügbar — zeige fallback option
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Kontocenter ist auf diesem Gerät nicht verfügbar. Bitte versuche es später oder kontaktiere den Support.',
          ),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _customerCenterBusy = false;
        });
      }
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
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      border: Border.all(color: scheme.outline, width: 1),
                    ),
                    child: Text(
                      'Audit-Check: Käufe wiederherstellen, Customer Center öffnen und Angebote laden müssen auch dann funktionieren, wenn RevenueCat zeitweise nicht antwortet.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
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
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Icon(
                                    Icons.inventory_2_outlined,
                                    size: 36,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Keine Angebote verfügbar.',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Wenn das so bleibt, liegt das Problem meist an Setup, Produkttypen oder einer fehlenden Offering-Konfiguration.',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView(
                            children: _offerings!.all.values
                                .map((offering) => _buildOffering(offering))
                                .toList(),
                          ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _loading ? null : _loadOfferings,
                    child: const Text('Angebote aktualisieren'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _restoreBusy ? null : _restore,
                    child: _restoreBusy
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Käufe wiederherstellen'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _customerCenterBusy ? null : _openCustomerCenter,
                    child: _customerCenterBusy
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Customer Center öffnen'),
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
                  onPressed: _purchaseBusy ? null : () => _buyPackage(pkg),
                  child: _purchaseBusy
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Kaufen'),
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
