import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/iap_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/godmode_colors.dart';
import '../../domain/providers/iap_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({this.highlightGodmode = false, super.key});

  final bool highlightGodmode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iapAsync = ref.watch(iapProvider);

    return AppDecoratedScaffold(
      appBar: null,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Header
          Container(
            color: AppColors.red,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'PREMIUM',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Voller Zugang zu\nDas Kapital',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Features list
                _FeatureSection(
                  features: const <_Feature>[
                    _Feature(
                      icon: Icons.bolt_rounded,
                      title: 'MARX GODMODE',
                      description:
                          'Nur die intensivsten Marx & Engels Zitate, maximales Design',
                      isHighlighted: true,
                    ),
                    _Feature(
                      icon: Icons.favorite_rounded,
                      title: 'Unbegrenzte Favoriten',
                      description:
                          'Speichere so viele Zitate wie du möchtest (Free: max. 10)',
                    ),
                    _Feature(
                      icon: Icons.picture_as_pdf_outlined,
                      title: 'PDF-Export',
                      description:
                          'Exportiere Zitate und Zusammenfassungen als PDF',
                    ),
                    _Feature(
                      icon: Icons.psychology_outlined,
                      title: 'Alle Denker-Zitate',
                      description:
                          'Voller Zugang zu Philosophen & Politikern aus aller Zeit',
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Product options
                _ProductCard(
                  productId: IapProductIds.godmodeLifetime,
                  title: '☭ GODMODE – Einmalig',
                  price: '4,99 €',
                  description: 'Einmaliger Kauf, dauerhafter Zugang zu GODMODE',
                  isHighlighted: highlightGodmode,
                  onPurchase: () =>
                      ref.read(iapProvider.notifier).purchase(
                        IapProductIds.godmodeLifetime,
                      ),
                ),
                const SizedBox(height: 12),
                _ProductCard(
                  productId: IapProductIds.monthlyPremium,
                  title: 'Premium – Monatlich',
                  price: '1,99 € / Monat',
                  description:
                      'Alle Premium-Features inkl. GODMODE und PDF-Export',
                  onPurchase: () =>
                      ref.read(iapProvider.notifier).purchase(
                        IapProductIds.monthlyPremium,
                      ),
                ),
                const SizedBox(height: 12),
                _ProductCard(
                  productId: IapProductIds.yearlyPremium,
                  title: 'Premium – Jährlich',
                  price: '14,99 € / Jahr',
                  description:
                      'Spare 37% gegenüber dem Monatsabo – alle Premium-Features',
                  badge: 'BESTES ANGEBOT',
                  onPurchase: () =>
                      ref.read(iapProvider.notifier).purchase(
                        IapProductIds.yearlyPremium,
                      ),
                ),
                const SizedBox(height: 24),

                iapAsync.when(
                  data: (state) {
                    if (state.isPremium) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: AppColors.saved,
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Premium aktiv',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.red),
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Käufe können in den App-Store-Einstellungen verwaltet werden.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      color: AppColors.inkMuted,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  const _Feature({
    required this.icon,
    required this.title,
    required this.description,
    this.isHighlighted = false,
  });
  final IconData icon;
  final String title;
  final String description;
  final bool isHighlighted;
}

class _FeatureSection extends StatelessWidget {
  const _FeatureSection({required this.features});
  final List<_Feature> features;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((f) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 32,
                height: 32,
                color: f.isHighlighted
                    ? GodmodeColors.accent
                    : AppColors.red,
                child: Icon(f.icon, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      f.title,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: f.isHighlighted
                            ? GodmodeColors.accent
                            : AppColors.ink,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      f.description,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        color: AppColors.inkLight,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.productId,
    required this.title,
    required this.price,
    required this.description,
    required this.onPurchase,
    this.badge,
    this.isHighlighted = false,
  });

  final String productId;
  final String title;
  final String price;
  final String description;
  final VoidCallback onPurchase;
  final String? badge;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final borderColor = isHighlighted ? GodmodeColors.accent : AppColors.ink;
    final bgColor = isHighlighted ? GodmodeColors.background : AppColors.paper;
    final titleColor = isHighlighted ? GodmodeColors.accent : AppColors.ink;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: isHighlighted ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (badge != null)
            Container(
              color: AppColors.red,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                badge!,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                    ),
                    Text(
                      price,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    color: isHighlighted
                        ? GodmodeColors.textMuted
                        : AppColors.inkLight,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: onPurchase,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    color: isHighlighted ? GodmodeColors.accent : AppColors.red,
                    child: Text(
                      'KAUFEN',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
