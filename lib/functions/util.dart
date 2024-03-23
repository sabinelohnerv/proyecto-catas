import 'dart:math';

bool isValidEmail(String value) {
  if (value.contains('@')) {
    return true;
  } else {
    return false;
  }
}

bool isValidPassword(String value){
  if (value.length>=6) {
    return true;
  } else {
    return false;
  }
}

String generateRandomCode() {
  const String allowedCharacters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%&*-_=+./?';
  final Random random = Random();
  String code = '';

  for (int i = 0; i < 10; i++) {
    int randomIndex = random.nextInt(allowedCharacters.length);
    code += allowedCharacters[randomIndex];
  }

  return code;
}
