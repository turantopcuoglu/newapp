/// Turkish locale-aware string helper utilities.
///
/// Dart's built-in [String.toLowerCase] and [String.toUpperCase] do not handle
/// the Turkish İ/ı and I/i mapping correctly. This helper provides proper
/// Turkish locale conversions.
class TurkishStringHelper {
  TurkishStringHelper._();

  /// Turkish lowercase mapping:
  /// İ → i, I → ı, Ş → ş, Ç → ç, Ğ → ğ, Ö → ö, Ü → ü
  static String toLowerCaseTr(String input) {
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      switch (char) {
        case 'İ':
          buffer.write('i');
          break;
        case 'I':
          buffer.write('ı');
          break;
        default:
          buffer.write(char.toLowerCase());
      }
    }
    return buffer.toString();
  }

  /// Turkish uppercase mapping:
  /// i → İ, ı → I, ş → Ş, ç → Ç, ğ → Ğ, ö → Ö, ü → Ü
  static String toUpperCaseTr(String input) {
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      switch (char) {
        case 'i':
          buffer.write('İ');
          break;
        case 'ı':
          buffer.write('I');
          break;
        default:
          buffer.write(char.toUpperCase());
      }
    }
    return buffer.toString();
  }

  /// Returns true if [source] contains [query] using Turkish locale-aware
  /// case-insensitive comparison.
  static bool containsTr(String source, String query) {
    return toLowerCaseTr(source).contains(toLowerCaseTr(query));
  }
}
