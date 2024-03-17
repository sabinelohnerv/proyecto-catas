import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catas_univalle/models/judge.dart';

class JudgeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Judge>> getJudges() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    List<Judge> judges = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Judge(
        fullName: data['fullName'],
        email: data['email'],
        birthDate: data['birthDate'],
        gender: data['gender'],
        dislikes: data['dislikes'],
        symptoms: List<String>.from(data['symptoms']),
        smokes: data['smokes'],
        cigarettesPerDay: data['cigarettesPerDay'],
        coffee: data['coffee'],
        coffeeCupsPerDay: data['coffeeCupsPerDay'],
        llajua: data['llajua'],
        seasonings: List<String>.from(data['seasonings']),
        sugarInDrinks: data['sugarInDrinks'],
        allergies: List<String>.from(data['allergies']),
        comment: data['comment'],
        applicationState: data['applicationState'],
      );
    }).toList();

    return judges;
  }
}
