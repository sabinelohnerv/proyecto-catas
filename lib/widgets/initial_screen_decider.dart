import 'dart:async';
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
  final StreamController<Widget> _initialScreenController = StreamController<Widget>();

  @override
  void initState() {
    super.initState();
    _setupStreams();
  }

  void _setupStreams() {
    _checkOnboarding();
    FirebaseAuth.instance.authStateChanges().listen((currentUser) async {
      if (currentUser != null && currentUser.emailVerified) {
        final userRole = await _authService.getUserRole(currentUser.uid);
        _handleUserRole(userRole);
      } else if (currentUser != null && !currentUser.emailVerified) {
        _initialScreenController.add(const VerificationView());
      } else {
        _initialScreenController.add(const LoginView());
      }
    });
  }

  void _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingComplete = prefs.getBool('onboardingComplete') ?? false;

    if (!onboardingComplete) {
      _initialScreenController.add(const OnBoardingPage());
    }
  }

  void _handleUserRole(String? userRole) {
    switch (userRole) {
      case 'admin':
      case 'admin-2':
        _initialScreenController.add(const AdminHomeView());
        break;
      case 'judge':
        _initialScreenController.add(const UserHomeView());
        break;
      default:
        _initialScreenController.add(const LoginView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Widget>(
      stream: _initialScreenController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return snapshot.data!;
        }
      },
    );
  }

  @override
  void dispose() {
    _initialScreenController.close();
    super.dispose();
  }
}
