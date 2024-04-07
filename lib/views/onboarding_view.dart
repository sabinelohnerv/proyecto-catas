// ignore_for_file: use_build_context_synchronously

import 'package:catas_univalle/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
  }

  Widget buildPageContent(BuildContext context, String title, String body) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            body,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<PageViewModel> getPages(BuildContext context) {
    return [
      PageViewModel(
        titleWidget: const SizedBox.shrink(),
        bodyWidget: buildPageContent(
          context,
          "Detrás de Cada Bocado",
          "Garantizamos la excelencia desde la selección de ingredientes hasta el disfrute del consumidor mediante evaluaciones sensoriales integrales.",
        ),
        image: Image.asset(
          'assets/images/tabla.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        decoration: const PageDecoration(
          pageColor: Color.fromRGBO(178, 247, 239, 1),
          imagePadding: EdgeInsets.zero,
          bodyPadding: EdgeInsets.all(6),
        ),
      ),
      PageViewModel(
        titleWidget: const SizedBox.shrink(),
        bodyWidget: buildPageContent(
          context,
          "Los Artífices del Sabor",
          "Seleccionamos y capacitamos expertos para ofrecer análisis sensoriales precisos, asegurando la superioridad de cada producto.",
        ),
        image: Image.asset(
          'assets/images/receta.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        decoration: const PageDecoration(
          pageColor: Color.fromRGBO(253, 255, 182, 1),
          imagePadding: EdgeInsets.zero,
          bodyPadding: EdgeInsets.all(6),
        ),
      ),
      PageViewModel(
        titleWidget: const SizedBox.shrink(),
        bodyWidget: buildPageContent(
          context,
          "Al Servicio del Paladar",
          "Nuestra aplicación agiliza el proceso de evaluación, desde la gestión de paneles hasta el análisis de datos, mejorando la calidad y la aceptación de los alimentos en el mercado.",
        ),
        image: Image.asset(
          'assets/images/app.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        decoration: PageDecoration(
          pageColor: Theme.of(context).primaryColor,
          imagePadding: EdgeInsets.zero,
          bodyPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: getPages(context),
      onDone: () async {
        await _completeOnboarding();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      },
      showNextButton: true,
      next: const Icon(Icons.arrow_forward),
      done: const Text("REGISTRATE!",
          style: TextStyle(fontWeight: FontWeight.w800)),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: const Color(0xFFBDBDBD),
        activeSize: const Size(22.0, 10.0),
        activeColor: Theme.of(context).primaryColor,
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      showSkipButton: false,
    );
  }
}
