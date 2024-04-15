import 'package:catas_univalle/functions/util.dart';
import 'package:catas_univalle/services/admin_service.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class RegisterAdminViewModel with ChangeNotifier {
  final AdminService _adminService = AdminService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _role;
  String? get role => _role;

  String? _password;
  String? get password => _password;

  File? _profileImage;
  File? get profileImage => _profileImage;

  final List<String> roleOptions = ['Administrador', 'Súper Administrador'];

  TextEditingController passwordController = TextEditingController();

  set name(String? newName) {
    _name = newName;
    notifyListeners();
  }

  set email(String? newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  set role(String? newRole) {
    _role = newRole;
    notifyListeners();
  }

  set password(String? newPassword) {
    _password = newPassword;
    notifyListeners();
  }

  set profileImage(File? newImage) {
    _profileImage = newImage;
    notifyListeners();
  }

  void randomizePassword() {
    String randomPassword = generateRandomPassword();
    _password = randomPassword;
    passwordController.text = randomPassword;
    notifyListeners();
  }

  Future<bool> registerAdmin() async {
    if (_email == null || _name == null || _role == null || _password == null) {
      _errorMessage = "Por favor completa todos los campos.";
      notifyListeners();
      return false;
    }

    if (_role == 'Administrador') {
      _role = 'admin-2';
    } else {
      _role = 'admin';
    }

    String profileImgUrl = _profileImage?.path ?? "";
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _adminService.registerAdmin(
          _email!, _password!, _name!, profileImgUrl, _role!);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
