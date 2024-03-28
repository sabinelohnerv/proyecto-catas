import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:catas_univalle/views/webview_screen.dart';

class EventFormView extends StatelessWidget {
  final String formUrl;
  const EventFormView({Key? key, required this.formUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Información del Evento',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white), 
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
          child: const Text(
            'Iniciar Cuestionario',
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
          style: ElevatedButton.styleFrom(
          ),
        ),
      ),
    );
  }
}
