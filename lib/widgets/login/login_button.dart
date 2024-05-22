// ignore_for_file: use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:catas_univalle/view_models/login_viewmodel.dart';
import 'package:catas_univalle/views/admin_home_view.dart';
import 'package:catas_univalle/views/user_home_view.dart';
import 'package:catas_univalle/views/verification_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginButton extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final LoginViewModel viewModel;

  const LoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.viewModel,
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool _isLoading = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              final email = widget.emailController.text.trim();
              final password = widget.passwordController.text.trim();
              final success = await widget.viewModel.login(email, password);

              if (success) {
                updateTokenAndNavigate();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Inicio de sesión fallido')),
                );
                setState(() {
                  _isLoading = false;
                });
              }
            },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(350, 10),
        elevation: 5,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : const Text(
              'INICIAR SESION',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
    );
  }

  void updateTokenAndNavigate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await _firebaseMessaging.getToken();
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'fcmToken': token,
      });

      final isVerified = await widget.viewModel.isEmailVerified();
      if (isVerified) {
        final userRole = await widget.viewModel.getUserRole();
        switch (userRole) {
          case 'admin':
          case 'admin-2':
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const AdminHomeView()));
            break;
          case 'judge':
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const UserHomeView()));
            break;
          default:
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const VerificationView()));
            break;
        }
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const VerificationView()));
      }
    }
  }
}
