import 'package:flutter/material.dart';
import 'package:catas_univalle/views/webview_screen.dart';

class EventFormView extends StatelessWidget {
  final String formUrl;
  const EventFormView({super.key, required this.formUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Información del Evento',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white), 
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WebViewScreen(formUrl: formUrl),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
          ),
          child: const Text(
            'Iniciar Cuestionario',
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
      ),
    );
  }
}
