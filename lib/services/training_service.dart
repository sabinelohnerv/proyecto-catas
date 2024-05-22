import 'package:catas_univalle/models/event_judge.dart';
import 'package:rxdart/rxdart.dart';
import '/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catas_univalle/models/training.dart';

class TrainingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<Event, int>> fetchAllEventsWithTrainings() async {
    Map<Event, int> eventTrainingCounts = {};
    try {
      var eventSnapshot = await _db.collection('events').get();
      for (var eventDoc in eventSnapshot.docs) {
        var event = Event.fromSnapshot(eventDoc);
        var trainingSnapshot = await _db
            .collection('events')
            .doc(event.id)
            .collection('trainings')
            .get();
        int trainingCount = trainingSnapshot.docs.length;
        eventTrainingCounts[event] = trainingCount;
      }
    } catch (e) {
      print('Failed to fetch events with trainings: $e');
      throw Exception('Failed to fetch events with trainings');
    }
    return eventTrainingCounts;
  }

  Future<void> addTraining(String eventId, Training training) async {
    try {
      await _db
          .collection('events')
          .doc(eventId)
          .collection('trainings')
          .add(training.toJson());
    } catch (e) {
      print('Error al agregar una capacitación: $e');
      throw Exception('Error al agregar una capacitación');
    }
  }

  Future<void> updateTraining(String eventId, Training training) async {
    try {
      await _db
          .collection('events')
          .doc(eventId)
          .collection('trainings')
          .doc(training.id)
          .set(training.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('Error al actualizar una capacitación: $e');
      throw Exception('Error al actualizar una capacitación');
    }
  }

  Future<void> deleteTraining(String eventId, String trainingId) async {
    try {
      await _db
          .collection('events')
          .doc(eventId)
          .collection('trainings')
          .doc(trainingId)
          .delete();
    } catch (e) {
      print('Error al eliminar una capacitación: $e');
      throw Exception('Error al eliminar una capacitación');
    }
  }

  Stream<List<Training>> getTrainings(String eventId) {
    return _db
        .collection('events')
        .doc(eventId)
        .collection('trainings')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Training.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    });
  }

  Stream<List<EventJudge>> getJudgesAssistanceStream(
      String eventId, String trainingId) {
    return FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .collection('trainings')
        .doc(trainingId)
        .snapshots()
        .map((snapshot) {
      var judgesList = snapshot['judges'] as List<dynamic>;
      List<EventJudge> judges =
          judgesList.map((j) => EventJudge.fromMap(j)).toList();
      judges.sort((a, b) => a.name.compareTo(b.name));
      return judges;
    });
  }

  Future<void> addOrUpdateTrainingJudges(String eventId, String trainingId,
      List<EventJudge> trainingJudges) async {
    List<Map<String, dynamic>> judgesMap = trainingJudges
        .map((j) => {
              'id': j.id,
              'name': j.name,
              'email': j.email,
              'state': j.state,
              'imgUrl': j.imgUrl,
              'fcmToken': j.fcmToken,
              'gender': j.gender
            })
        .toList();

    await _db
        .collection('events')
        .doc(eventId)
        .collection('trainings')
        .doc(trainingId)
        .update({
      'judges': judgesMap,
    });
  }

  Stream<Map<Event, int>> fetchAllEventsWithTrainingCountsStream() {
    Stream<List<Event>> eventStream = _db.collection('events').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Event.fromSnapshot(doc)).toList());
    return eventStream.switchMap((events) {
      if (events.isEmpty) {
        return Stream.value({});
      } else {
        List<Stream<Map<Event, int>>> trainingCountStreams =
            events.map((event) {
          return _db
              .collection('events')
              .doc(event.id)
              .collection('trainings')
              .snapshots()
              .map((snapshot) {
            return {event: snapshot.docs.length};
          });
        }).toList();
        return CombineLatestStream.list(trainingCountStreams)
            .map((List<Map<Event, int>> counts) {
          return counts.fold({}, (Map<Event, int> accumulator, map) {
            accumulator.addAll(map);
            return accumulator;
          });
        });
      }
    });
  }
}
