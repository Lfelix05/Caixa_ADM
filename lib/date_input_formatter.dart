import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    final numbersOnly = text.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbersOnly.length <
        oldValue.text.replaceAll(RegExp(r'[^0-9]'), '').length) {
      return newValue;
    }

    if (numbersOnly.length > 8) {
      return oldValue;
    }

    String formatted = '';
    for (int i = 0; i < numbersOnly.length; i++) {
      if (i == 2 || i == 4) {
        formatted += '/';
      }
      formatted += numbersOnly[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

DateTime? parseDate(String dateText) {
  if (dateText.isEmpty) return null;

  final numbersOnly = dateText.replaceAll(RegExp(r'[^0-9]'), '');

  if (numbersOnly.length != 8) return null;

  try {
    final day = int.parse(numbersOnly.substring(0, 2));
    final month = int.parse(numbersOnly.substring(2, 4));
    final year = int.parse(numbersOnly.substring(4, 8));

    return DateTime(year, month, day);
  } catch (e) {
    return null;
  }
}
