import 'package:catas_univalle/views/client_list_view.dart';
import 'package:catas_univalle/views/judge_list_view.dart';
import 'package:flutter/material.dart';

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

  void navigateToJudgeList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JudgeListView()),
    );
  }

  void navigateToClientList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ClientListView()),
    );
  }
}
