import 'dart:io';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/models/event_judge.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;

class EventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> uploadEventLogo(File logo, String eventId) async {
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('event_images/${Path.basename(logo.path)}');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(logo);
    await uploadTask;
    String url = await storageReference.getDownloadURL();
    return url;
  }

  Future<void> addEvent(Event event) async {
    await _db.collection('events').doc(event.id).set({
      'name': event.name,
      'date': event.date,
      'start': event.start,
      'end': event.end,
      'location': event.location,
      'locationUrl': event.locationUrl,
      'about': event.about,
      'imageUrl': event.imageUrl,
      'code': event.code,
      'formUrl': event.formUrl,
      'allergyRestrictions': event.allergyRestrictions,
      'symptomRestrictions': event.symptomRestrictions,
      'client': {
        'id': event.client.id,
        'name': event.client.name,
        'email': event.client.email,
        'logoImgUrl': event.client.logoImgUrl
      },
      'numberOfJudges': event.numberOfJudges,
      'eventJudges': event.eventJudges,
    });
  }

  Stream<List<Event>> eventsStream() {
    return _db.collection('events').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromSnapshot(doc)).toList();
    });
  }

  Stream<Event> fetchEventById(String eventId) {
    return _db.collection('events').doc(eventId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Event.fromSnapshot(snapshot);
      } else {
        throw Exception("No se encontró el evento.");
      }
    });
  }

  Future<void> addOrUpdateSelectedJudges(
      String eventId, List<EventJudge> selectedJudges) async {
    List<Map<String, dynamic>> judgesMap = selectedJudges
        .map((j) => {
              'id': j.id,
              'name': j.name,
              'email': j.email,
              'state': j.state,
              'imgUrl': j.imgUrl,
            })
        .toList();

    await _db.collection('events').doc(eventId).update({
      'eventJudges': judgesMap,
    });
  }

  Future<void> deleteEvent(String eventId) async {
    await _db.collection('events').doc(eventId).delete();
  }

  Stream<List<EventJudge>> getSelectedJudgesStream(String eventId) {
    return FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .snapshots()
        .map((snapshot) {
      var judgesList = snapshot['eventJudges'] as List;
      return judgesList.map((j) => EventJudge.fromMap(j)).toList();
    });
  }

  Future<List<Event>> fetchEventsForJudge(String judgeId) async {
    List<Event> eventsForJudge = [];
    try {
      var eventsSnapshot = await _db.collection('events').get();

      for (var doc in eventsSnapshot.docs) {
        var event = Event.fromSnapshot(doc);
        bool isJudgeSelected = event.eventJudges.any((judge) => judge.id == judgeId);
        if (isJudgeSelected) {
          eventsForJudge.add(event);
        }
      }
      return eventsForJudge;
    } catch (e) {
      print("Error fetching events for judge: $e");
      return [];
    }
  }
}