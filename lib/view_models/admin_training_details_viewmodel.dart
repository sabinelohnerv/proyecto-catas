// ignore_for_file: use_build_context_synchronously

import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/views/training_judges_view.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

class AdminTrainingDetailsViewModel extends ChangeNotifier {
  Training training;
  final String eventId;

  AdminTrainingDetailsViewModel(this.training, this.eventId);

  void viewPDF(BuildContext context) async {
    if (training.pdfUrl != null && training.pdfUrl!.isNotEmpty) {
      final result = await OpenFilex.open(training.pdfUrl!);
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error al abrir el PDF: ${result.message}')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay un documento PDF disponible.')));
    }
  }

  void goToTrainingJudgesView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TrainingJudgesView(eventId: eventId, trainingId: training.id),
      ),
    );
  }

  void updateTrainingDetails(Training updatedTraining) {
    training = updatedTraining;
    notifyListeners();
  }
}
