import 'package:catas_univalle/view_models/profile_viewmodel.dart';
import 'package:catas_univalle/views/invitations_view.dart';
import 'package:catas_univalle/views/judge_selected_events_view.dart';
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
              margin: const EdgeInsets.all(24),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/catas-univalle.appspot.com/o/event_images%2Fcookies_cata.jpg?alt=media&token=95a975a3-b448-4fc5-8bce-28c1e49922e2',
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 20,
                runSpacing: 20, 
                alignment:
                    WrapAlignment.spaceAround, 
                children: [
                  SimpleSectionCard(
                    img: 'food',
                    title: 'Catas',
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
                    img: 'cocinero',
                    title: 'Perfil',
                    subtitle: 'Ver perfil',
                    destinationScreen: ProfileView(),
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
          ],
        ),
      ),
    );
  }
}
