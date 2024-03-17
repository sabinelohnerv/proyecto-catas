import 'package:flutter/material.dart';
import '/view_models/home_viewmodel.dart'; 

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = HomeViewModel(); 

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('HOME'),
            ElevatedButton(
              onPressed: () => viewModel.navigateToJudgeList(context),
              child: const Text('Ver lista de Jueces'),
            ),
          ],
        ),
      ),
    );
  }
}
