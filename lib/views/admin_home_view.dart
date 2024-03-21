import 'package:catas_univalle/view_models/profile_viewmodel.dart';
import 'package:catas_univalle/views/login_view.dart';
import 'package:flutter/material.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  void _handleSignOut(BuildContext context) async {
    final ProfileViewModel viewModel = ProfileViewModel();
    bool signedOut = await viewModel.signOut();
    if (signedOut) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ProfileViewModel(); 
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Admin Home'),
            ElevatedButton(
              onPressed: () => viewModel.navigateToJudgeList(context),
              child: const Text('Lista de Jueces'),
            ),
            ElevatedButton(
              onPressed: () => viewModel.navigateToClientList(context),
              child: const Text('Clientes'),
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
