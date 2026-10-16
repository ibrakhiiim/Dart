// Формат цены: 649 990 ₸
String formatPrice(int amount) {
  const nbsp = '\u00A0';
  final digits = amount.abs().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(nbsp);
    buffer.write(digits[i]);
  }

  final sign = amount < 0 ? '-' : '';
  return '$sign$buffer$nbsp₸';
}
