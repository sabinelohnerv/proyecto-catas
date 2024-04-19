class Training {
  String id;
  String name;
  String description;
  String imageUrl;
  String startTime;
  String endTime;
  String date;
  String location;
  String locationUrl;
  String pdfUrl;

  Training({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.location,
    required this.locationUrl,
    required this.pdfUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'startTime': startTime,
      'endTime': endTime,
      'date': date,
      'location': location,
      'locationUrl': locationUrl,
      'pdfUrl': pdfUrl,
    };
  }

  factory Training.fromJson(Map<String, dynamic> data) {
    return Training(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      startTime: data['startTime'],
      endTime: data['endTime'],
      date: data['date'],
      location: data['location'],
      locationUrl: data['locationUrl'],
      pdfUrl: data['pdfUrl'],
    );
  }
}
