import 'dart:math';
import 'package:intl/intl.dart';

bool isValidEmail(String value) {
  if (value.contains('@')) {
    return true;
  } else {
    return false;
  }
}

bool isValidPassword(String value) {
  if (value.length >= 6) {
    return true;
  } else {
    return false;
  }
}

String generateRandomCode() {
  const String allowedCharacters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%&*-_=+./?';
  final Random random = Random();
  String code = '';

  for (int i = 0; i < 10; i++) {
    int randomIndex = random.nextInt(allowedCharacters.length);
    code += allowedCharacters[randomIndex];
  }

  return code;
}

String formatDateToWrittenDate(String inputDate) {
  DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(inputDate);

  String formattedDate =
      DateFormat('dd MMMM yyyy', 'es_ES').format(parsedDate);

  return formattedDate.toUpperCase();
}
