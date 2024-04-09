import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/training_event.dart';

class TrainingEventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTrainingEvent(TrainingEvent trainingEvent) async {
    await _db.collection('trainingEvents').add(trainingEvent.toMap());
  }

  Stream<List<TrainingEvent>> getTrainingEvents() {
    return _db.collection('trainingEvents').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TrainingEvent.fromSnapshot(doc)).toList();
    });
  }
}
