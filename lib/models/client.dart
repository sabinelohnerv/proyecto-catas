import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  String id;
  String name;
  String logoImgUrl;
  String email;

  Client({
    required this.id,
    required this.name,
    required this.logoImgUrl,
    required this.email,
  });

  factory Client.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Client(
      id: snapshot.id,
      name: data['name'],
      logoImgUrl: data['logoImgUrl'],
      email: data['email'],
    );
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      name: map['name'],
      logoImgUrl: map['logoImgUrl'],
      email: map['email'],
    );
  }

  factory Client.placeholder() {
    return Client(
      id: 'placeholder_client_id',
      name: 'Placeholder Client Name',
      logoImgUrl: 'http://placeholder.com/logo.jpg',
      email: 'placeholder@example.com',
    );
  }
}
