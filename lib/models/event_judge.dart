class EventJudge {
  final String id;
  final String name;
  final String email;
  final String state;
  final String imgUrl;
  String? fcmToken;

  EventJudge({
    required this.id,
    required this.name,
    required this.email,
    required this.state,
    required this.imgUrl,
    this.fcmToken,
  });

  factory EventJudge.fromMap(Map<String, dynamic> map) {
    return EventJudge(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        state: map['state'],
        fcmToken: map['fcmToken'],
        imgUrl: map['imgUrl']);
  }
}
