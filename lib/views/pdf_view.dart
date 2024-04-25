import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewPage extends StatefulWidget {
  final String pdfPath;

  const PDFViewPage({Key? key, required this.pdfPath}) : super(key: key);

  @override
  _PDFViewPageState createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documento'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: PDFView(
        filePath: widget.pdfPath,
        autoSpacing: false,
        enableSwipe: true,
        pageSnap: false,
        swipeHorizontal: true,
        nightMode: false,
      ),
    );
  }
}
