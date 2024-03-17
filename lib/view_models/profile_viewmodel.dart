import '../services/auth_service.dart';

class ProfileViewModel {
  final _authService = AuthService();

  Future<bool> signOut() async {
    try {
      await _authService.signOut();
      return true; 
    } catch (e) {
      print("Error signing out: $e");
      return false;
    }
  }
}
