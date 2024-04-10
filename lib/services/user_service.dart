import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/judge.dart';

class UserService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    if (userId.isEmpty) {
      return null;
    }

    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<bool> updateJudgeDetails(Judge judge) async {
    try {
      await _firestore.collection('users').doc(judge.id).update({
        'dislikes': judge.dislikes,
        'symptoms': judge.symptoms,
        'smokes': judge.smokes,
        'cigarettesPerDay': judge.cigarettesPerDay,
        'coffee': judge.coffee,
        'coffeeCupsPerDay': judge.coffeeCupsPerDay,
        'llajua': judge.llajua,
        'seasonings': judge.seasonings,
        'sugarInDrinks': judge.sugarInDrinks,
        'allergies': judge.allergies,
        'comment': judge.comment,
        'reliability': judge.reliability
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
