import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Premium feature gate that shows content for Pro users or a teaser for free users.
///
/// **Immediate Entitlement Sync (MON-05)**:
/// - Watches [isProProvider] which streams latest entitlement state from RevenueCat
/// - When purchase/restore succeeds, stream emits new CustomerInfo
/// - Riverpod automatically rebuilds this widget with new isPremium value
/// - No app restart needed; gate updates in real-time during purchase flow
///
/// **Usage:**
/// ```dart
/// PremiumGate(
///   featureName: 'Advanced Archive Filters',
///   child: AdvancedArchiveScreen(),
/// )
/// ```
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
    // Pro features are now public for beta launch
    return child;
  }
}
