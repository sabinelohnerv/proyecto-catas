class EventJudge {
  final String id;
  final String name;
  final String email;
  final String state;
  final String imgUrl;
  final String gender;
  String? fcmToken;

  EventJudge({
    required this.id,
    required this.name,
    required this.email,
    required this.state,
    required this.imgUrl,
    required this.gender,
    this.fcmToken,
  });

  factory EventJudge.fromMap(Map<String, dynamic> map) {
    return EventJudge(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        state: map['state'],
        gender: map['gender'],
        fcmToken: map['fcmToken'],
        imgUrl: map['imgUrl']);
  }
}
