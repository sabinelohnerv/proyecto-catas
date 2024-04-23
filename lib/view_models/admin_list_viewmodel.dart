import 'package:catas_univalle/models/admin.dart';
import 'package:catas_univalle/services/admin_service.dart';
import 'package:catas_univalle/services/auth_service.dart';
import 'package:catas_univalle/views/register_admin_view.dart';
import 'package:flutter/material.dart';

class AdminListViewModel extends ChangeNotifier {
  final AdminService _adminService = AdminService();
  final AuthService _authService = AuthService();

  List<Admin> _admins = [];
  List<Admin> get admins => _admins;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AdminListViewModel() {
    listenToAdmins();
  }

  void listenToAdmins() {
  _isLoading = true;
  notifyListeners();

  _adminService.adminsStream().listen(
    (adminData) {
      _admins = adminData;
      _isLoading = false;
      notifyListeners();
    },
    onError: (error) {
      print("Error cargando admins: $error");
      _isLoading = false;
      notifyListeners();
    }
  );
}


  void navigateToRegisterAdmin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterAdminView()),
    );
  }

  bool isAdminCurrentUser(Admin admin) {
    String? currentUserId = _authService.getCurrentUserId();
    return currentUserId != null && admin.id == currentUserId;
  }
}
