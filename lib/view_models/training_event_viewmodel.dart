import 'package:flutter/material.dart';
import 'package:catas_univalle/models/training_event.dart';
import 'package:catas_univalle/services/training_event_service.dart';

class TrainingEventListViewModel with ChangeNotifier {
  List<TrainingEvent> _trainingEvents = [];
  final TrainingEventService _trainingEventService = TrainingEventService();

  List<TrainingEvent> get trainingEvents => _trainingEvents;

  void loadTrainingEvents() async {
    notifyListeners();
  }

  Future<void> addTrainingEvent(TrainingEvent trainingEvent) async {
    await _trainingEventService.addTrainingEvent(trainingEvent);
    _trainingEvents.add(trainingEvent);
    notifyListeners();
  }
}

