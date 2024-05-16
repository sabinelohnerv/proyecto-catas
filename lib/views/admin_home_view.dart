import 'package:catas_univalle/view_models/profile_viewmodel.dart';
import 'package:catas_univalle/views/admin_event_list_view.dart';
import 'package:catas_univalle/views/admin_training_events_view.dart';
import 'package:catas_univalle/views/client_list_view.dart';
import 'package:catas_univalle/views/judge_list_view.dart';
import 'package:catas_univalle/views/login_view.dart';
import 'package:catas_univalle/widgets/home/small_card.dart';
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
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      drawer: CustomDrawer(
        fullName: userViewModel.fullName,
        email: userViewModel.email,
        imageUrl: userViewModel.imageUrl,
        role: userViewModel.role,
        onSignOut: () => _handleSignOut(context, userViewModel),
        isAdmin: true,
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

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: HomeEventsCarousel(
                            events: viewModel.events, isAdmin: true),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            spacing: 25,
                            runSpacing: 25,
                            children: [
                              SmallCard(
                                img: 'food',
                                title: 'Eventos',
                                width: 150,
                                destinationScreen:
                                    AdminEventListView(isAdmin: true),
                              ),
                              SmallCard(
                                img: 'jueces',
                                title: 'Jueces',
                                width: 160,
                                destinationScreen: JudgeListView(),
                              ),
                              SmallCard(
                                img: 'clientes',
                                title: 'Anfitriones',
                                width: 150,
                                destinationScreen: ClientListView(),
                              ),
                              SmallCard(
                                img: 'book',
                                title: 'Capacitacion',
                                width: 150,
                                destinationScreen: AdminTrainingEventsView(),
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
