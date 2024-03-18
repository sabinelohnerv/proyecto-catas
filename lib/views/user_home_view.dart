import 'package:catas_univalle/view_models/profile_viewmodel.dart';
import 'package:catas_univalle/views/login_view.dart';
import 'package:flutter/material.dart';

class UserHomeView extends StatelessWidget {
  const UserHomeView({super.key});

  void _handleSignOut(BuildContext context) async {
    final ProfileViewModel viewModel = ProfileViewModel();
    bool signedOut = await viewModel.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ProfileViewModel();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('User Home'),
            ElevatedButton(
              onPressed: () => viewModel.navigateToJudgeList(context), // Asegúrate de que este método esté implementado
              child: const Text('Lista de Jueces'),
            ),
            ElevatedButton(
              onPressed: () => _handleSignOut(context),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
