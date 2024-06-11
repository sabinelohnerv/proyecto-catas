import '../services/auth_service.dart';

class LoginViewModel {
  final _authService = AuthService();

  Future<bool> login(String email, String password) async {
    return await _authService.signIn(email, password);
  }

  Future<String?> getUserRole() async {
    String? userId = _authService.getCurrentUserId();
    if (userId != null) {
      return await _authService.getUserRole(userId);
    }
    return null;
  }

  Future<bool> isEmailVerified() async {
    return _authService.isEmailVerified();
  }

  Future<bool> resetPassword(String email) async {
    return await _authService.sendPasswordResetEmail(email);
  }
}
