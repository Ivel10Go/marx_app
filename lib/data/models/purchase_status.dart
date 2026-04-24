enum PurchaseStatus { free, premium }

class PurchaseState {
  const PurchaseState({
    required this.status,
    required this.hasGodmode,
    required this.activeProductId,
  });

  final PurchaseStatus status;
  final bool hasGodmode;
  final String? activeProductId;

  bool get isPremium => status == PurchaseStatus.premium || hasGodmode;

  const PurchaseState.free()
    : status = PurchaseStatus.free,
      hasGodmode = false,
      activeProductId = null;

  PurchaseState copyWith({
    PurchaseStatus? status,
    bool? hasGodmode,
    String? activeProductId,
  }) {
    return PurchaseState(
      status: status ?? this.status,
      hasGodmode: hasGodmode ?? this.hasGodmode,
      activeProductId: activeProductId ?? this.activeProductId,
    );
  }
}
