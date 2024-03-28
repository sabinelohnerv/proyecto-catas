import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final String formUrl;

  const WebViewScreen({Key? key, required this.formUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cuestionario',
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: colorScheme.primary, 
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      body: WebViewWidget(url: formUrl),
    );
  }
}

class WebViewWidget extends StatelessWidget {
  final String url;

  const WebViewWidget({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
