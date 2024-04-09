import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingEvent {
  String id;
  String title;
  String description;
  List<String> objectives;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  String location;
  String linkedCataEventId; 

  TrainingEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.objectives,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.linkedCataEventId, 
  });

  factory TrainingEvent.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return TrainingEvent(
      id: snapshot.id,
      title: data['title'],
      description: data['description'],
      objectives: List<String>.from(data['objectives']),
      startDate: data['startDate'],
      endDate: data['endDate'],
      startTime: data['startTime'],
      endTime: data['endTime'],
      location: data['location'],
      linkedCataEventId: data['linkedCataEventId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'objectives': objectives,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'linkedCataEventId': linkedCataEventId, 
    };
  }
}
