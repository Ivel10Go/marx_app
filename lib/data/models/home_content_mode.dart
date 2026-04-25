enum HomeContentMode {
  quotes,
  facts,
  mixed;

  static HomeContentMode fromStorage(String? raw) {
    return HomeContentMode.values.firstWhere(
      (HomeContentMode value) => value.name == raw,
      orElse: () => HomeContentMode.quotes,
    );
  }
}
