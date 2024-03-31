import 'package:catas_univalle/view_models/profile_viewmodel.dart';
import 'package:catas_univalle/views/admin_event_list_view.dart';
import 'package:catas_univalle/views/client_list_view.dart';
import 'package:catas_univalle/views/judge_list_view.dart';
import 'package:catas_univalle/views/login_view.dart';
import 'package:catas_univalle/widgets/profile/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/admin_event_list_viewmodel.dart';
import '../widgets/events/event_carousel.dart';
import 'admin_profile_view.dart';

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
            ChangeNotifierProvider<AdminEventListViewModel>(
              create: (_) => AdminEventListViewModel(),
              child: Consumer<AdminEventListViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const SizedBox(
                        height: 350,
                        child: Center(child: CircularProgressIndicator()));
                  }

                  return HomeEventsCarousel(
                      events: viewModel.events, isAdmin: true);
                },
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
                      destinationScreen: AdminEventListView(
                        isAdmin: true,
                      ),
                    ),
                    SimpleSectionCard(
                      img: 'cocinero',
                      title: 'Perfil',
                      subtitle: 'Ver perfil',
                      destinationScreen: AdminProfileView(),
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
