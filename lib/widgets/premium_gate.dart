import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/providers/purchases_provider.dart';

class PremiumGate extends ConsumerWidget {
  const PremiumGate({
    required this.child,
    this.featureName = 'Pro-Feature',
    this.featureDescription = 'Dieses Feature ist Teil von Zitate App Pro.',
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
    final scheme = Theme.of(context).colorScheme;

    return Container(
      color: scheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // ─── Rotes Kicker-Band ──────────────────
          Container(
            color: scheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'PRO',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: scheme.onPrimary,
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
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        featureDescription,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 13,
                          height: 1.6,
                          color: scheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/purchase');
                    },
                    child: Text(
                      'PRO FREISCHALTEN',
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
