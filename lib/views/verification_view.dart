import 'package:catas_univalle/widgets/verification/verification_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/services/auth_service.dart';
import 'package:catas_univalle/views/user_home_view.dart';
import 'package:catas_univalle/views/login_view.dart';

class VerificationView extends StatelessWidget {
  const VerificationView({super.key});

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const UserHomeView()),
    );
  }

  void _handleSignOut(BuildContext context, AuthService authService) async {
    await authService.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: null,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _handleSignOut(context, authService),
            color: Colors.white,
            iconSize: 30,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/verification.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: FutureBuilder<bool>(
              future: authService.isEmailVerified(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.data == true) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _navigateToHome(context);
                  });
                  return const SizedBox();
                } else {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Spacer(flex: 4),
                        VerificationCard(),
                        Spacer(flex: 1),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
