// ignore_for_file: use_build_context_synchronously

import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

class JudgeTrainingDetailsViewModel extends ChangeNotifier {
  final Training training;
  final AuthService _authService = AuthService();
  String _attendanceStatus = 'PENDIENTE';

  JudgeTrainingDetailsViewModel(this.training) {
    checkAttendance(); 
  }

  String get attendanceStatus => _attendanceStatus;

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

  Future<String?> getUserId() async {
    return _authService.getCurrentUserId();
  }

  Future<void> checkAttendance() async {
    String? userId = await getUserId();
    DateFormat format = DateFormat('dd-MM-yyyy');
    DateTime trainingDate;
    try {
      trainingDate = format.parse(training.date);
    } catch (e) {
      _attendanceStatus = 'ERROR AL CARGAR';
      notifyListeners();
      return;
    }
    if (userId != null && training.judges.any((judge) => judge.id == userId)) {
      var judge = training.judges.firstWhere((judge) => judge.id == userId);
      _attendanceStatus = judge.state == 'P' ? 'PRESENTE' : 'AUSENTE';
    } else if (DateTime.now().isBefore(trainingDate)) {
      _attendanceStatus = 'PENDIENTE';
    } else {
      _attendanceStatus = 'AUSENTE';
    }
    notifyListeners();
  }
}
