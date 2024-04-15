import 'package:catas_univalle/services/auth_service.dart';
import 'package:catas_univalle/views/admin_home_view.dart';
import 'package:catas_univalle/views/login_view.dart';
import 'package:catas_univalle/views/onboarding_view.dart';
import 'package:catas_univalle/views/user_home_view.dart';
import 'package:catas_univalle/views/verification_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialScreenDecider extends StatefulWidget {
  const InitialScreenDecider({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InitialScreenDeciderState();
  }
}

class _InitialScreenDeciderState extends State<InitialScreenDecider> {
  final AuthService _authService = AuthService();

  Future<Widget> getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingComplete = prefs.getBool('onboardingComplete') ?? false;

    if (!onboardingComplete) {
      return const OnBoardingPage();
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      final userRole = await _authService.getUserRole(currentUser.uid);
      switch (userRole) {
        case 'admin':
        case 'admin-2':
          return const AdminHomeView();
        case 'judge':
          return const UserHomeView();
        default:
          return const LoginView();
      }
    } else if (currentUser != null && !currentUser.emailVerified) {
      return const VerificationView(); 
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
              body: Center(child: CircularProgressIndicator()));
        } else {
          return snapshot.data ?? const OnBoardingPage();
        }
      },
    );
  }
}
