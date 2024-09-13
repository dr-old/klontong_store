import 'package:intl/intl.dart';
import 'dart:math';

String formatRupiah(int amount) {
  final formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  return formatCurrency.format(amount);
}

String generateSKU(String? prefix) {
  String label = prefix ?? "SKU";
  final now = DateTime.now();
  final formattedDate =
      '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  final random = Random();
  final randomNumber = random.nextInt(100000);

  return '$label$formattedDate${randomNumber.toString().padLeft(5, '0')}';
}
