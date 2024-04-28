import 'package:catas_univalle/models/event_judge.dart';
import 'package:catas_univalle/services/training_service.dart';
import 'package:flutter/material.dart';

class TrainingJudgesViewModel extends ChangeNotifier {
  final TrainingService _trainingService = TrainingService();
  final String eventId;
  final String trainingId;

  Stream<List<EventJudge>>? trainingJudgesStream;

  TrainingJudgesViewModel(this.eventId, this.trainingId) {
    _loadJudgesAssistance();
  }

  void _loadJudgesAssistance() {
    trainingJudgesStream =
        _trainingService.getJudgesAssistanceStream(eventId, trainingId);
    notifyListeners();
  }
}
