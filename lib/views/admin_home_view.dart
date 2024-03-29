import 'package:catas_univalle/view_models/profile_viewmodel.dart';
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
        title: const Text(
          'FoodSense',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
        ),
        foregroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
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
              height: 280,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/catas-univalle.appspot.com/o/event_images%2Fcookies_cata.jpg?alt=media&token=574d2978-3240-4425-b3f2-c42a64b089c2',
                fit: BoxFit.cover,
              ),
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
                  spacing: 25,
                  runSpacing: 25,
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
