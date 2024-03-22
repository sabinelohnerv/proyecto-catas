import 'package:catas_univalle/view_models/profile_viewmodel.dart';
import 'package:catas_univalle/views/login_view.dart';
import 'package:catas_univalle/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/profile/profile_card.dart';

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
    final userViewModel = Provider.of<ProfileViewModel>(context);
    userViewModel.loadCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleSignOut(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text("Placeholder")),
            ),
            Container(
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                'Bienvenido, ${userViewModel.fullName}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SimpleSectionCard(
                    img: 'food',
                    title: 'Catas',
                    subtitle: 'Ver más',
                    isClickable: false,
                  ),
                  SimpleSectionCard(
                    img: 'cocinero',
                    title: 'Perfil',
                    subtitle: 'Ver perfil',
                    destinationScreen: ProfileView(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
