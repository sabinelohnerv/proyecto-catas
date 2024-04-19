import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catas_univalle/models/training.dart';

class TrainingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTraining(String eventId, Training training) async {
    try {
      await _db.collection('events').doc(eventId).collection('trainings').add(training.toJson());
    } catch (e) {
      print('Failed to add training: $e');
      throw Exception('Failed to add training');
    }
  }

  Future<void> updateTraining(String eventId, Training training) async {
    try {
      await _db.collection('events').doc(eventId).collection('trainings').doc(training.id)
        .set(training.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('Failed to update training: $e');
      throw Exception('Failed to update training');
    }
  }

  Future<void> deleteTraining(String eventId, String trainingId) async {
    try {
      await _db.collection('events').doc(eventId).collection('trainings').doc(trainingId).delete();
    } catch (e) {
      print('Failed to delete training: $e');
      throw Exception('Failed to delete training');
    }
  }

  Stream<List<Training>> getTrainings(String eventId) {
    return _db.collection('events').doc(eventId).collection('trainings').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Training.fromJson({
        ...doc.data() as Map<String, dynamic>,
        'id': doc.id,
      })).toList();
    });
  }
}
