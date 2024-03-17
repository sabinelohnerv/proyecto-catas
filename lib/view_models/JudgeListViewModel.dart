import 'package:flutter/material.dart';
import '../services/auth_service.dart'; 
import '../models/judge.dart'; 

class JudgeListViewModel {
  final AuthService _authService = AuthService();

  Future<List<Judge>> fetchJudges() async {
    try {
      return [];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
