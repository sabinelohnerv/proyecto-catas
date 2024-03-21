import 'dart:io';

import 'package:catas_univalle/services/user_service.dart';
import 'package:catas_univalle/views/client_list_view.dart';
import 'package:catas_univalle/views/judge_list_view.dart';
import 'package:catas_univalle/views/profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final _authService = AuthService();
  final _userService = UserService();
  User? _currentUser;
  Map<String, dynamic>? _userDetails;

  User? get currentUser => _currentUser;
  Map<String, dynamic>? get userDetails => _userDetails;

  Future<void> loadCurrentUser() async {
    _currentUser = _userService.getCurrentUser();
    if (_currentUser != null) {
      _userDetails = await _userService.getUserDetails(_currentUser!.uid);
    }
    notifyListeners();
  }

  Future<bool> signOut() async {
    try {
      await _authService.signOut();
      return true;
    } catch (e) {
      print("Error signing out: $e");
      return false;
    }
  }

  // Getters

  String get imageUrl =>
      _userDetails?['image_url'] ??
      'https://firebasestorage.googleapis.com/v0/b/catas-univalle.appspot.com/o/user_profile_images%2FdKgpYVBtrINmWNUbHaFzbTfLIR43.jpg?alt=media&token=ec449f94-cb81-4939-acef-cb3f9802652a';
  String get fullName => _userDetails?['fullName'] ?? 'Nombre no disponible';
  String get email => _userDetails?['email'] ?? 'Email no disponible';
  String get birthDate =>
      _userDetails?['birthDate'] ?? 'Fecha de nacimiento no disponible';
  String get gender => _userDetails?['gender'] ?? 'Género no disponible';
  String get dislikes => _userDetails?['dislikes'] ?? 'Sin dislikes';
  List<String> get symptoms => List.from(_userDetails?['symptoms'] ?? []);
  bool get smokes => _userDetails?['smokes'] ?? false;
  int get cigarettesPerDay => _userDetails?['cigarettesPerDay'] ?? 0;
  String get coffee => _userDetails?['coffee'] ?? 'Nunca';
  int get coffeeCupsPerDay => _userDetails?['coffeeCupsPerDay'] ?? 0;
  String get llajua => _userDetails?['llajua'] ?? 'Nunca';
  List<String> get seasonings => List.from(_userDetails?['seasonings'] ?? []);
  int get sugarInDrinks => _userDetails?['sugarInDrinks'] ?? 0;
  List<String> get allergies => List.from(_userDetails?['allergies'] ?? []);
  String get comment => _userDetails?['comment'] ?? '';
  String get applicationState =>
      _userDetails?['applicationState'] ?? 'Estado no disponible';

  Future<void> updateProfileImage(File image, String userId) async {
    String? imageUrl;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_profile_images')
        .child('$userId.jpg');

    await storageRef.putFile(image);
    imageUrl = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'image_url': imageUrl,
    });

    await loadCurrentUser();
  }

  void navigateToJudgeList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JudgeListView()),
    );
  }

  void navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileView()),
    );
  }

  navigateToClientList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ClientListView()),
    );
  }
}
