import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catas_univalle/models/judge.dart';

class JudgeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Judge>> getJudges() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    List<Judge> judges = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      Judge judge = Judge(
        id: doc.id,
        fullName: data['fullName'] ?? '',
        email: data['email'] ?? '',
        birthDate: data['birthDate'] ?? '',
        gender: data['gender'] ?? '',
        dislikes: data['dislikes'] ?? '',
        symptoms: List<String>.from(data['symptoms'] ?? []),
        smokes: data['smokes'] ?? false,
        cigarettesPerDay: data['cigarettesPerDay'] ?? 0,
        coffee: data['coffee'] ?? '',
        coffeeCupsPerDay: data['coffeeCupsPerDay'] ?? 0,
        llajua: data['llajua'] ?? '',
        seasonings: List<String>.from(data['seasonings'] ?? []),
        sugarInDrinks: data['sugarInDrinks'] ?? 0,
        allergies: List<String>.from(data['allergies'] ?? []),
        comment: data['comment'] ?? '',
        applicationState: data['applicationState'] ?? '',
        profileImgUrl: data['profileImgUrl'] ?? ''
      );

      judges.add(judge);
    }

    return judges;
  }
}
