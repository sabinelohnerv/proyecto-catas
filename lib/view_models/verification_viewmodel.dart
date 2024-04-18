import 'dart:async';
import 'package:flutter/foundation.dart'; // For using ChangeNotifier
import 'package:catas_univalle/services/auth_service.dart';

class VerificationViewModel with ChangeNotifier {
  Timer? _timer;
  final AuthService _authService = AuthService();
  final VoidCallback onVerificationComplete;

  VerificationViewModel(this.onVerificationComplete) {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (await _authService.isEmailVerified()) {
        _timer?.cancel();
        notifyListeners();
        onVerificationComplete(); 
      }
    });
  }

  Future<bool> resendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<bool> signOut() async {
    try {
      await _authService.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}
