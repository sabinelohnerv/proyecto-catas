import 'package:flutter/material.dart';
import '/views/JudgeListScreen.dart';

class HomeViewModel {
  void navigateToJudgeList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JudgeListScreen()),
    );
  }
}
