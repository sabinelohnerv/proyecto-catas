import 'package:catas_univalle/view_models/profile_viewmodel.dart';
import 'package:catas_univalle/views/add_event_view.dart';
import 'package:catas_univalle/views/admin_event_list_view.dart';
import 'package:catas_univalle/views/client_list_view.dart';
import 'package:catas_univalle/views/judge_list_view.dart';
import 'package:catas_univalle/views/login_view.dart';
import 'package:catas_univalle/views/profile_view.dart';
import 'package:catas_univalle/widgets/profile/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    SimpleSectionCard(
                      img: 'food',
                      title: 'Catas',
                      subtitle: 'Ver más',
                      destinationScreen: AdminEventListView(),
                    ),
                    SimpleSectionCard(
                      img: 'cocinero',
                      title: 'Perfil',
                      subtitle: 'Ver perfil',
                      destinationScreen: ProfileView(),
                    ),
                    SimpleSectionCard(
                      img: 'jueces',
                      title: 'Jueces',
                      subtitle: 'Lista de jueces',
                      destinationScreen: JudgeListView(),
                    ),
                    SimpleSectionCard(
                      img: 'clientes',
                      title: 'Clientes',
                      subtitle: 'Ver clientes',
                      destinationScreen: ClientListView(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
