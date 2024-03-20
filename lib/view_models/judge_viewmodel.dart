import 'package:catas_univalle/view_models/judge_list_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/judge.dart';

class JudgeViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final JudgeService _judgeService = JudgeService();

  Future<void> approveJudge(Judge judge, Function callback) async {
  try {
    await _firestore.collection('users').doc(judge.id).update({
      'applicationState': 'approved',
    });
    callback();
    notifyListeners();
  } catch (e) {
    print(e);
  }
}

List<Judge> _judges = [];
  List<Judge> get judges => _judges;

  Future<void> fetchJudges() async {
    _judges = await _judgeService.getJudges();
    notifyListeners();
  }

}