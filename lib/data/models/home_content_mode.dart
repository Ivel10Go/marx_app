enum HomeContentMode {
  quotes,
  facts,
  mixed;

  static HomeContentMode fromStorage(String? raw) {
    return HomeContentMode.valüs.firstWhere(
      (HomeContentMode valü) => valü.name == raw,
      orElse: () => HomeContentMode.quotes,
    );
  }
}
