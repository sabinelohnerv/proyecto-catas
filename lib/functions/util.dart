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