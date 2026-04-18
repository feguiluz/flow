import 'package:flutter/services.dart';

/// Phone formatter for Mexican phone numbers
///
/// Formats numbers as: (XXX) XXX-XXXX
/// Example: (812) 345-6789
class MexicanPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Get only digits
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Limit to 10 digits
    if (text.length > 10) {
      return oldValue;
    }

    // Build formatted string
    final buffer = StringBuffer();

    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Format: (XXX) XXX-XXXX
    if (text.length >= 1) {
      buffer.write('(');
      buffer.write(text.substring(0, text.length < 3 ? text.length : 3));

      if (text.length >= 3) {
        buffer.write(') ');
        buffer.write(text.substring(3, text.length < 6 ? text.length : 6));

        if (text.length >= 6) {
          buffer.write('-');
          buffer.write(text.substring(6, text.length));
        }
      }
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Format a phone number string to Mexican format
///
/// Example: "8123456789" → "(812) 345-6789"
String formatMexicanPhone(String phone) {
  // Remove all non-digits
  final digits = phone.replaceAll(RegExp(r'[^\d]'), '');

  if (digits.isEmpty) {
    return '';
  }

  // Limit to 10 digits
  final limited = digits.substring(0, digits.length > 10 ? 10 : digits.length);

  // Format: (XXX) XXX-XXXX
  final buffer = StringBuffer();

  if (limited.length >= 1) {
    buffer.write('(');
    buffer.write(limited.substring(0, limited.length < 3 ? limited.length : 3));

    if (limited.length >= 3) {
      buffer.write(') ');
      buffer
          .write(limited.substring(3, limited.length < 6 ? limited.length : 6));

      if (limited.length >= 6) {
        buffer.write('-');
        buffer.write(limited.substring(6));
      }
    }
  }

  return buffer.toString();
}

/// Remove formatting from Mexican phone number
///
/// Example: "(812) 345-6789" → "8123456789"
String unformatMexicanPhone(String formattedPhone) {
  return formattedPhone.replaceAll(RegExp(r'[^\d]'), '');
}
