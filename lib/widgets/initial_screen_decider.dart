import 'package:catas_univalle/services/auth_service.dart';
import 'package:catas_univalle/views/admin_home_view.dart';
import 'package:catas_univalle/views/login_view.dart';
import 'package:catas_univalle/views/user_home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InitialScreenDecider extends StatefulWidget {
  const InitialScreenDecider({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InitialScreenDeciderState();
  }
}

class _InitialScreenDeciderState extends State<InitialScreenDecider> {
  final AuthService _authService = AuthService();

  Future<Widget> getInitialScreen() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userRole = await _authService.getUserRole(currentUser.uid);
      switch (userRole) {
        case 'admin':
          return const AdminHomeView();
        case 'judge':
          return const UserHomeView();
        default:
          return const LoginView();
      }
    } else {
      return const LoginView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: getInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return snapshot.data ?? const LoginView();
        }
      },
    );
  }
}
