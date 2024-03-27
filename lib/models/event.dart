import 'package:catas_univalle/models/client.dart';
import 'package:catas_univalle/models/event_judge.dart';
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
  List<EventJudge> eventJudges;

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
      required this.eventJudges});

  factory Event.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return Event(
      id: snapshot.id,
      name: data['name'],
      date: data['date'],
      start: data['start'],
      end: data['end'],
      location: data['location'],
      locationUrl: data['locationUrl'],
      about: data['about'],
      imageUrl: data['imageUrl'],
      code: data['code'],
      formUrl: data['formUrl'],
      allergyRestrictions: List<String>.from(data['allergyRestrictions']),
      symptomRestrictions: List<String>.from(data['symptomRestrictions']),
      client: Client.fromMap(data['client'] as Map<String, dynamic>),
      numberOfJudges: data['numberOfJudges'],
      eventJudges: (data['eventJudges'] as List<dynamic>?)
              ?.map((e) => EventJudge.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  factory Event.placeholder() {
    return Event(
      id: 'placeholder_id',
      name: 'Placeholder Name',
      date: '01-01-2000',
      start: '00:00',
      end: '00:00',
      location: 'Placeholder Location',
      locationUrl: 'http://example.com',
      about: 'This is a placeholder about text.',
      imageUrl: 'http://placeholder.com/image.jpg',
      code: '0000',
      formUrl: 'http://example.com/form',
      allergyRestrictions: [],
      symptomRestrictions: [],
      client: Client.placeholder(),
      numberOfJudges: 0,
      eventJudges: [],
    );
  }
}
