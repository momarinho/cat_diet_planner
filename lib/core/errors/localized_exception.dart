class LocalizedException implements Exception {
  const LocalizedException(this.key, {this.args = const {}});

  final String key;
  final Map<String, Object> args;
}
