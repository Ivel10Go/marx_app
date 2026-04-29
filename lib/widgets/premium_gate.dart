import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/providers/purchases_provider.dart';
import '../core/theme/app_colors.dart';

class PremiumGate extends ConsumerWidget {
  const PremiumGate({
    required this.child,
    this.featureName = 'Feature',
    this.featureDescription = 'Dieses Feature ist nur in Premium verfügbar.',
    super.key,
  });

  final Widget child;
  final String featureName;
  final String featureDescription;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isProProvider);

    if (isPremium) {
      return child;
    }

    return _PremiumTeaser(
      featureName: featureName,
      featureDescription: featureDescription,
    );
  }
}

class _PremiumTeaser extends StatelessWidget {
  const _PremiumTeaser({
    required this.featureName,
    required this.featureDescription,
  });

  final String featureName;
  final String featureDescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.paper,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // ─── Rotes Kicker-Band ──────────────────
          Container(
            color: AppColors.red,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'PREMIUM',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppColors.redOnRed,
                letterSpacing: 1.8,
              ),
            ),
          ),
          // ─── Inhalt ────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        featureName.toUpperCase(),
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        featureDescription,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 13,
                          height: 1.6,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/purchase');
                    },
                    child: Text(
                      'PREMIUM FREISCHALTEN',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
