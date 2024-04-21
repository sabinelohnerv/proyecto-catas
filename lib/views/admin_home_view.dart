import 'package:catas_univalle/view_models/profile_viewmodel.dart';
import 'package:catas_univalle/views/admin_event_list_view.dart';
import 'package:catas_univalle/views/client_list_view.dart';
import 'package:catas_univalle/views/judge_list_view.dart';
import 'package:catas_univalle/views/login_view.dart';
import 'package:catas_univalle/views/training_list_view.dart';
import 'package:catas_univalle/widgets/profile/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/admin_event_list_viewmodel.dart';
import '../widgets/events/event_carousel.dart';
import '../widgets/home/drawer.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  void _handleSignOut(BuildContext context, ProfileViewModel viewModel) async {
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
      ),
      drawer: CustomDrawer(
        fullName: userViewModel.fullName,
        email: userViewModel.email,
        imageUrl: userViewModel.imageUrl,
        role: userViewModel.role,
        onSignOut: () => _handleSignOut(context, userViewModel),
        isAdmin: false,
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

                  String lastEventId = viewModel.events.isNotEmpty
                      ? viewModel.events.last.id
                      : 'defaultEventId';

                  return Column(
                    children: [
                      HomeEventsCarousel(
                          events: viewModel.events, isAdmin: true),
                      Container(
                        color: Theme.of(context).primaryColor,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Text(
                          'Bienvenido, ${userViewModel.fullName}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            spacing: 25,
                            runSpacing: 25,
                            children: [
                              const SimpleSectionCard(
                                img: 'food',
                                title: 'Eventos',
                                subtitle: 'Ver más',
                                width: 160,
                                destinationScreen:
                                    AdminEventListView(isAdmin: true),
                              ),
                              const SimpleSectionCard(
                                img: 'jueces',
                                title: 'Jueces',
                                subtitle: 'Lista de jueces',
                                width: 160,
                                destinationScreen: JudgeListView(),
                              ),
                              const SimpleSectionCard(
                                img: 'clientes',
                                title: 'Anfitriones',
                                subtitle: 'Ver anfitriones',
                                width: 160,
                                destinationScreen: ClientListView(),
                              ),
                              SimpleSectionCard(
                                img: 'book',
                                title: 'Capacitaciones',
                                subtitle: 'Aprende ahora',
                                width: 160,
                                destinationScreen: TrainingListView(
                                  isAdmin: true,
                                  eventId: lastEventId,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}