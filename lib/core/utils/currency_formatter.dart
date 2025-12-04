import 'package:intl/intl.dart';

/// Utility class for formatting currency values
class CurrencyFormatter {
  static final _formatter = NumberFormat('#,##0', 'en_US');

  /// Format a double value as currency with comma separators
  /// Example: 12345.67 -> "$12,345"
  static String format(double amount) {
    return '\$${_formatter.format(amount.round())}';
  }

  /// Format a double value as currency with decimals
  /// Example: 12345.67 -> "$12,345.67"
  static String formatWithDecimals(double amount) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return '\$${formatter.format(amount)}';
  }
}
