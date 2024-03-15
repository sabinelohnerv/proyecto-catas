import 'package:catas_univalle/models/judge.dart';

import '../services/auth_service.dart';

class RegisterViewModel {
  final _authService = AuthService();

  Future<bool> register(Judge judge, String password) async {
    return await _authService.judgeRegister(judge, password);
  }
}
