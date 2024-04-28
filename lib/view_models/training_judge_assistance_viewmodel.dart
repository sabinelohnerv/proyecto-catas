import 'package:catas_univalle/models/event_judge.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:flutter/material.dart';

class TrainingJudgeAssistanceViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();
  final String eventId;

  Stream<List<EventJudge>>? selectedJudgesStream;

  TrainingJudgeAssistanceViewModel(this.eventId) {
    _loadSelectedJudges();
  }

  void _loadSelectedJudges() {
    selectedJudgesStream = _eventService.getSelectedJudgesStream(eventId);
    notifyListeners();
  }
}
