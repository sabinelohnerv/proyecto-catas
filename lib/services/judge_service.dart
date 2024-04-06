import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catas_univalle/models/judge.dart';

class JudgeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Judge>> getJudges() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    List<Judge> judges = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data['role'] == 'judge' &&
          data.containsKey('fullName') && data['fullName'].toString().isNotEmpty &&
          data.containsKey('email') && data['email'].toString().isNotEmpty &&
          data.containsKey('comment') && data['comment'].toString().isNotEmpty) {
        
        Judge judge = Judge(
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
          profileImgUrl: data['image_url'] ?? '',
          roleAsJudge: data['roleAsJudge'],
          hasTime: data['hasTime']
        );
        judges.add(judge);
      }
    }

    return judges;
  }
}
