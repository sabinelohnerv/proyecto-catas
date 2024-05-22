import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class PDFViewModel extends ChangeNotifier {
  Future<void> viewPDF(String url) async {
    try {
      var file = await downloadFile(url);
      var result = await OpenFilex.open(file.path);
      print('Open file result: ${result.message}');
    } catch (e) {
      print('Error opening file: $e');
    }
  }

  Future<File> downloadFile(String url) async {
    var response = await http.get(Uri.parse(url));
    var documentDirectory = await getApplicationDocumentsDirectory();
    var filePathAndName = '${documentDirectory.path}/downloaded_file.pdf';
    File file = File(filePathAndName);
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }
}
