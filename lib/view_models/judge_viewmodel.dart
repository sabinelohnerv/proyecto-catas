import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/judge.dart';
import '../services/judge_service.dart';

class JudgeViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final JudgeService _judgeService = JudgeService();

  List<Judge> _judges = [];
  List<Judge> get judges => _judges;

  JudgeViewModel() {
    fetchJudges();
  }

  Future<void> updateJudgeApplicationState(Judge judge, String newState, Function callback) async {
    try {
      await _firestore.collection('users').doc(judge.id).update({
        'applicationState': newState,
      });
      callback();
      await fetchJudges();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchJudges() async {
    _judges = await _judgeService.getJudges();
    notifyListeners();
  }
}
