import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catas_univalle/models/judge.dart';

class JudgeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Judge>> getJudges() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    List<Judge> judges = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      bool hasAllRequiredFields = data['fullName'] != null && data['email'] != null &&
          data['birthDate'] != null && data['gender'] != null &&
          data['dislikes'] != null && data['symptoms'] != null && data['symptoms'].isNotEmpty &&
          data['smokes'] != null && data['cigarettesPerDay'] != null &&
          data['coffee'] != null && data['coffeeCupsPerDay'] != null &&
          data['llajua'] != null && data['seasonings'] != null && data['seasonings'].isNotEmpty &&
          data['sugarInDrinks'] != null && data['allergies'] != null && data['allergies'].isNotEmpty &&
          data['comment'] != null && data['applicationState'] != null;

      if (hasAllRequiredFields) {
        judges.add(Judge(
          id: doc.id,
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
        ));
      }
    }
    return judges;
  }
}
