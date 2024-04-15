import 'package:cloud_firestore/cloud_firestore.dart';

class Admin {
  String id;
  String name;
  String email;
  String profileImgUrl;
  String role;

  Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImgUrl,
    required this.role
  });

  factory Admin.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Admin(
      id: snapshot.id,
      name: data['fullName'],
      email: data['email'],
      profileImgUrl: data['image_url'],
      role: data['role']
    );
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['id'],
      name: map['fullName'],
      email: map['email'],
      profileImgUrl: map['image_url'],
      role: map['role']
    );
  }

  factory Admin.placeholder() {
    return Admin(
      id: 'placeholder_admin_id',
      name: 'Placeholder Admin Name',
      profileImgUrl: 'http://placeholder.com/logo.jpg',
      email: 'placeholder@example.com',
      role: 'admin-2'
    );
  }
}
