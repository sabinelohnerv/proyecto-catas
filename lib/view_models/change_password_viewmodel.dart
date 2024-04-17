import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  String currentPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void setCurrentPassword(String value) {
    currentPassword = value;
    notifyListeners();
  }

  void setNewPassword(String value) {
    newPassword = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    confirmPassword = value;
    notifyListeners();
  }

  Future<bool> changePassword() async {
    if (newPassword != confirmPassword || newPassword.isEmpty) {
      return false; 
    }

    try {
      User? user = _firebaseAuth.currentUser;
      String email = user!.email!;

      AuthCredential credential = EmailAuthProvider.credential(email: email, password: currentPassword);
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);
      return true;
    } catch (e) {
      print('Error changing password: $e');
      return false;
    }
  }
}
