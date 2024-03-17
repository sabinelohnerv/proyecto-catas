import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/judge.dart';

class JudgeViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> approveJudge(Judge judge) async {
    try {
      await _firestore.collection('judges').doc(judge.email).update({
        'applicationState': 'approved',
      });
      // Notificar a los listeners en caso de que necesites actualizar la UI después de este cambio
      notifyListeners();
    } catch (e) {
      print(e); // Manejar el error adecuadamente
    }
  }
}