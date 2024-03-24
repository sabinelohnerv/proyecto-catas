import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  String id;
  String name;
  String logoImgUrl;
  String email;

  Client(
      {required this.id,
      required this.name,
      required this.logoImgUrl,
      required this.email});

  factory Client.fromSnapshot(DocumentSnapshot snapshot) {
    return Client(
      id: snapshot.id,
      name: snapshot['name'],
      logoImgUrl: snapshot['logoImgUrl'],
      email: snapshot['email'],
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
