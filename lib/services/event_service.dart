import 'dart:io';
import 'package:catas_univalle/models/event.dart';
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
}
