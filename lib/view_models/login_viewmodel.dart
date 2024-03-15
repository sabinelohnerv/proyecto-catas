import '../services/auth_service.dart';

class LoginViewModel {
  final _authService = AuthService();

  Future<bool> login(String email, String password) async {
    return await _authService.signIn(email, password);
  }
}
