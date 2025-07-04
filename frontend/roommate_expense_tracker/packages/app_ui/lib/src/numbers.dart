import 'package:intl/intl.dart';

String formatNumber(double number) {
  final formatter = NumberFormat("#,###.##");
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 100000) {
    return '${(number / 1000).toStringAsFixed(0)}k';
  } else {
    return formatter.format(number);
  }
}

String formatInt(int number) {
  final formatter = NumberFormat("#,###");
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 100000) {
    return '${(number / 1000).toStringAsFixed(0)}k';
  } else {
    return formatter.format(number);
  }
}

String formatCurrency(double value) {
  bool neg = false;
  if (value < 0) {
    neg = true;
    value = -value;
  }
  final formatter = NumberFormat("#,##0.00", "en_US");

  return '${neg ? '-' : ''}\$${formatter.format(value)}';
}

// Add this function (or put it in a dedicated utility file)
double calculatePercentChange(double current, double previous) {
  if (previous == 0) {
    if (current == 0) {
      return 0.0;
    } else {
      return double.infinity;
    }
  }
  return ((current - previous) / previous) * 100.0;
}

// Helper for formatting percent change (e.g., +13.5%, -5.2%)
String formatPercentChange(double percent) {
  if (percent == double.infinity) {
    return '--%';
  }
  // NumberFormat handles the sign and decimal places
  final formatter = NumberFormat('#,##0.0;#,##0.0');
  return '${formatter.format(percent)}%';
}
