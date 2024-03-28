import 'package:catas_univalle/views/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EventFormView extends StatelessWidget {
  final String formUrl;
  const EventFormView({Key? key, required this.formUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuestionario del Evento'),
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
          child: const Text('Iniciar Cuestionario'),
        ),
      ),
    );
  }
}
