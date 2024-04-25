import 'package:catas_univalle/models/training.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/foundation.dart';

class JudgeTrainingDetailsViewModel extends ChangeNotifier {
  final Training training;

  JudgeTrainingDetailsViewModel(this.training);

  void viewPDF(BuildContext context) async {
    if (training.pdfUrl != null && training.pdfUrl!.isNotEmpty) {
      final result = await OpenFilex.open(training.pdfUrl!);
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al abrir el PDF: ${result.message}'))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No hay un documento PDF disponible.'))
      );
    }
  }
}
