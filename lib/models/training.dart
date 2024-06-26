import 'package:catas_univalle/models/event_judge.dart';

class Training {
  String id;
  String name;
  String description;
  String startTime;
  String endTime;
  String date;
  String location;
  String? pdfUrl;
  List<EventJudge> judges;

  Training({
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.location,
    this.pdfUrl,
    required this.judges,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'date': date,
      'location': location,
      'pdfUrl': pdfUrl,
      'judges': judges.map((judge) => judge.toJson()).toList(),
    };
  }

  factory Training.fromJson(Map<String, dynamic> data) {
    return Training(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      startTime: data['startTime'],
      endTime: data['endTime'],
      date: data['date'],
      location: data['location'],
      pdfUrl: data['pdfUrl'],
      judges: (data['judges'] as List<dynamic>?)
              ?.map((e) => EventJudge.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  factory Training.placeholder() {
    return Training(
      id: 'id',
      name: 'name',
      description: 'description',
      startTime: 'startTime',
      endTime: 'endTime',
      date: 'date',
      location: 'location',
      pdfUrl: 'pdfUrl',
      judges: [],
    );
  }
}
