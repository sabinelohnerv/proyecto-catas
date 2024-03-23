import 'package:catas_univalle/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String name;
  String date;
  String start;
  String end;
  String location;
  String locationUrl;
  String about;
  String imageUrl;
  String code;
  String formUrl;
  List<String> allergyRestrictions;
  List<String> symptomRestrictions;
  Client client;
  int numberOfJudges;
  List<String> judgesEmails;

  Event(
      {required this.id,
      required this.name,
      required this.date,
      required this.start,
      required this.end,
      required this.location,
      required this.locationUrl,
      required this.about,
      required this.imageUrl,
      required this.code,
      required this.formUrl,
      required this.allergyRestrictions,
      required this.symptomRestrictions,
      required this.client,
      required this.numberOfJudges,
      required this.judgesEmails});

  factory Event.fromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot == null) {
      throw Exception('Document snapshot was null for event ${snapshot.id}');
    }
    return Event(
      id: snapshot.id,
      name: snapshot['name'],
      date: snapshot['date'],
      start: snapshot['start'],
      end: snapshot['end'],
      location: snapshot['location'],
      locationUrl: snapshot['locationUrl'],
      about: snapshot['about'],
      imageUrl: snapshot['imageUrl'],
      code: snapshot['code'],
      formUrl: snapshot['formUrl'],
      allergyRestrictions: List<String>.from(snapshot['allergyRestrictions']),
      symptomRestrictions: List<String>.from(snapshot['symptomRestrictions']),
      client: Client(
        id: snapshot['client']['id'],
        name: snapshot['client']['name'],
        logoImgUrl: snapshot['client']['logoImgUrl'],
        email: snapshot['client']['email'],
      ),
      numberOfJudges: snapshot['numberOfJudges'],
      judgesEmails: List<String>.from(snapshot['judgesEmails']),
    );
  }
}
