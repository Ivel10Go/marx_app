import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/iap_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/godmode_colors.dart';
import '../../../data/models/purchase_status.dart';
import '../../../domain/providers/iap_provider.dart';

class SubscriptionSection extends ConsumerWidget {
  const SubscriptionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iapAsync = ref.watch(iapProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(
          left: BorderSide(color: AppColors.ink, width: 1),
          right: BorderSide(color: AppColors.ink, width: 1),
          bottom: BorderSide(color: AppColors.ink, width: 1),
        ),
      ),
      child: iapAsync.when(
        data: (state) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Status header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: state.isPremium ? AppColors.saved : AppColors.ink,
              child: Row(
                children: <Widget>[
                  Icon(
                    state.isPremium
                        ? Icons.verified_rounded
                        : Icons.lock_outlined,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state.isPremium ? 'PREMIUM AKTIV' : 'KOSTENLOS',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  if (state.hasGodmode) ...<Widget>[
                    const SizedBox(width: 8),
                    Text(
                      '· ☭ GODMODE',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: GodmodeColors.accent,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (!state.isPremium) ...<Widget>[
                    Text(
                      state.status == PurchaseStatus.free
                          ? 'Schalte GODMODE, unbegrenzte Favoriten und mehr frei.'
                          : 'Dein Abo ist abgelaufen.',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        color: AppColors.inkLight,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => context.push('/paywall'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        color: AppColors.red,
                        child: Text(
                          'PREMIUM FREISCHALTEN',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ] else ...<Widget>[
                    Text(
                      'Alle Premium-Features aktiv.',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        color: AppColors.inkLight,
                      ),
                    ),
                    if (state.activeProductId != null) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        'Produkt: ${_productLabel(state.activeProductId!)}',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 10,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.red),
            ),
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  String _productLabel(String id) {
    switch (id) {
      case IapProductIds.monthlyPremium:
        return 'Monatlich';
      case IapProductIds.yearlyPremium:
        return 'Jährlich';
      case IapProductIds.godmodeLifetime:
        return 'GODMODE (einmalig)';
      case 'admin_grant':
        return 'Admin-Freischaltung';
      default:
        return id;
    }
  }
}
