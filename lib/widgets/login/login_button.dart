import 'package:flutter/material.dart';
import 'package:catas_univalle/view_models/login_viewmodel.dart';
import 'package:catas_univalle/views/admin_home_view.dart';
import 'package:catas_univalle/views/login_view.dart';
import 'package:catas_univalle/views/user_home_view.dart';
import 'package:catas_univalle/views/verification_view.dart'; 

class LoginButton extends StatefulWidget {
  const LoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.viewModel,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final LoginViewModel viewModel;

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : () async {
        setState(() {
          _isLoading = true;
        });
        final email = widget.emailController.text;
        final password = widget.passwordController.text;
        final success = await widget.viewModel.login(email, password);

        if (success) {
          final isVerified = await widget.viewModel.isEmailVerified();

          if (isVerified) {
            final userRole = await widget.viewModel.getUserRole();
            switch (userRole) {
              case 'admin':
              case 'admin-2':
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminHomeView()));
                break;
              case 'judge':
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const UserHomeView()));
                break;
              default:
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()));
                break;
            }
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const VerificationView()));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inicio de sesión fallido')),
          );
        }
        setState(() {
          _isLoading = false;
        });
      },
      style: ElevatedButton.styleFrom(
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
          : const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Iniciar Sesión', style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 28),
              ],
            ),
    );
  }
}
