import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catas_univalle/models/training.dart';

class TrainingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Agregar una nueva capacitación
  Future<void> addTraining(String eventId, Training training) async {
    await _db.collection('events').doc(eventId).collection('trainings').add(training.toJson());
  }

  // Actualizar una capacitación existente
  Future<void> updateTraining(String eventId, Training training) async {
    await _db.collection('events').doc(eventId).collection('trainings').doc(training.id).set(training.toJson(), SetOptions(merge: true));
  }

  // Eliminar una capacitación
  Future<void> deleteTraining(String eventId, String trainingId) async {
    await _db.collection('events').doc(eventId).collection('trainings').doc(trainingId).delete();
  }

  // Obtener todas las capacitaciones de un evento
  Stream<List<Training>> getTrainings(String eventId) {
  return _db
      .collection('events')
      .doc(eventId)
      .collection('trainings')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => Training.fromJson({
      ...doc.data(),
      'id': doc.id,
    })).toList();
  });
}

}
