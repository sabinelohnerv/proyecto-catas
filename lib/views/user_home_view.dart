import 'package:catas_univalle/view_models/profile_viewmodel.dart';
import 'package:catas_univalle/views/invitations_view.dart';
import 'package:catas_univalle/views/judge_selected_events_view.dart';
import 'package:catas_univalle/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/admin_event_list_viewmodel.dart';
import '../widgets/events/event_carousel.dart';
import '../widgets/home/drawer.dart';
import '../widgets/profile/profile_card.dart';

class UserHomeView extends StatelessWidget {
  const UserHomeView({super.key});

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
      ),
      drawer: CustomDrawer(
        fullName: userViewModel.fullName,
        email: userViewModel.email,
        imageUrl: userViewModel.imageUrl,
        isAdmin: false,
        onSignOut: () => _handleSignOut(context),
        role: false,
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
                      events: viewModel.events, isAdmin: false);
                },
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Center(
                child: Wrap(
                  spacing: 25,
                  runSpacing: 25,
                  alignment: WrapAlignment.center,
                  children: [
                    SimpleSectionCard(
                      img: 'food',
                      title: 'Eventos',
                      subtitle: 'Ver más',
                      isClickable: true,
                      onTap: () {
                        final String judgeId = userViewModel.currentUser!.uid;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                JudgeSelectedEventsView(judgeId: judgeId),
                          ),
                        );
                      },
                    ),
                    const SimpleSectionCard(
                      img: 'invitacion',
                      title: 'Invitaciones',
                      subtitle: 'Ver Más',
                      destinationScreen: InvitationsView(),
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
