import 'package:catas_univalle/view_models/profile_viewmodel.dart';
import 'package:catas_univalle/views/invitations_view.dart';
import 'package:catas_univalle/views/judge_selected_events_view.dart';
import 'package:catas_univalle/views/judge_training_events_view.dart';
import 'package:catas_univalle/views/login_view.dart';
import 'package:catas_univalle/widgets/home/large_card.dart';
import 'package:catas_univalle/widgets/home/small_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/admin_event_list_viewmodel.dart';
import '../view_models/judge_events_viewmodel.dart';
import '../widgets/events/event_carousel.dart';
import '../widgets/home/drawer.dart';

class UserHomeView extends StatelessWidget {
  const UserHomeView({super.key});

  void _handleSignOut(
      BuildContext context, ProfileViewModel userViewModel) async {
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
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
        child: Padding(
          padding: const EdgeInsets.only(top: 18.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChangeNotifierProvider<JudgeEventsViewModel>(
                create: (_) =>
                    JudgeEventsViewModel(userViewModel.currentUser!.uid),
                child: Consumer<JudgeEventsViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.isLoading) {
                      return const SizedBox(
                          height: 350,
                          child: Center(child: CircularProgressIndicator()));
                    }

                    return HomeEventsCarousel(
                      events: viewModel.events,
                      isAdmin: false,
                      userName: userViewModel.fullName,
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: SmallCard(
                            img: 'invitacion-2',
                            title: 'Invitaciones',
                            destinationScreen: InvitationsView(),
                            width: double.infinity,
                            height: 150,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: SmallCard(
                            img: 'cuaderno',
                            title: 'Capacitaciones',
                            isClickable: true,
                            onTap: () {
                              final String judgeId =
                                  userViewModel.currentUser!.uid;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      JudgeTrainingEventsView(judgeId: judgeId),
                                ),
                              );
                            },
                            width: double.infinity,
                            height: 150,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    LargeCard(
                      img: 'comer',
                      title: 'Eventos',
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
