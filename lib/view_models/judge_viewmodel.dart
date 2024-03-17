import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/judge.dart';

class JudgeViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> approveJudge(Judge judge) async {
    print("Actualizando el estado del juez con email: ${judge.email}"); 
    try {
      await _firestore.collection('users').doc(judge.email).update({
        'applicationState': 'approved',
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}


