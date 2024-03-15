import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catas_univalle/models/judge.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<bool> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> judgeRegister(Judge judge, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: judge.email, password: password);

      if (userCredential.user != null) {
        String userId = userCredential.user!.uid;
        await userCredential.user!.sendEmailVerification();

        await _firestore.collection('users').doc(userId).set({
          'fullName': judge.fullName,
          'email': judge.email,
          'birthDate': judge.birthDate,
          'gender': judge.gender,
          'dislikes': judge.dislikes,
          'symptoms': judge.symptoms,
          'smokes': judge.smokes,
          'cigarettesPerDay': judge.cigarettesPerDay,
          'coffee': judge.coffee,
          'coffeeCupsPerDay': judge.coffeeCupsPerDay,
          'llajua': judge.llajua,
          'llajuaPerDay': judge.llajuaPerDay,
          'seasonings': judge.seasonings,
          'sugarInDrinks': judge.sugarInDrinks,
          'allergies': judge.allergies,
          'comment': judge.comment,
          'applicationState': judge.applicationState,
        });

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
