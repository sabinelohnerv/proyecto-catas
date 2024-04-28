import 'package:flutter/material.dart';
import 'package:catas_univalle/models/event_judge.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/services/training_service.dart';

class TrainingJudgeAssistanceViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();
  final TrainingService _trainingService = TrainingService();
  final String eventId;
  final String trainingId;

  List<EventJudge> _selectedJudges = [];
  List<EventJudge> get selectedJudges => _selectedJudges;

  List<EventJudge> _trainingJudges = [];
  List<EventJudge> get trainingJudges => _trainingJudges;

  List<EventJudge> _combinedJudges = [];
  List<EventJudge> get combinedJudges => _combinedJudges;

  bool _isLoadingEvent = false;
  bool get isLoadingEvent => _isLoadingEvent;

  bool _isLoadingTraining = false;
  bool get isLoadingTraining => _isLoadingTraining;

  TrainingJudgeAssistanceViewModel(this.eventId, this.trainingId) {
    _listenToJudges();
  }

  void _listenToJudges() {
    _isLoadingEvent = true;
    _isLoadingTraining = true;
    notifyListeners();

    _eventService.getSelectedJudgesStream(eventId).listen((selectedJudgesData) {
      _selectedJudges = selectedJudgesData;
      _updateCombinedJudges();
      _isLoadingEvent = false;
      notifyListeners();
    });

    _trainingService
        .getJudgesAssistanceStream(eventId, trainingId)
        .listen((trainingJudgesData) {
      _trainingJudges = trainingJudgesData;
      _updateCombinedJudges();
      _isLoadingTraining = false;
      notifyListeners();
    });
  }

  void _updateCombinedJudges() {
    notifyListeners();

    Map<String, EventJudge> tempMap = {};
    _selectedJudges.forEach((judge) {
      tempMap[judge.id] = EventJudge(
          id: judge.id,
          name: judge.name,
          state: 'F',
          email: judge.email,
          gender: judge.gender,
          imgUrl: judge.imgUrl,
          fcmToken: judge.fcmToken);
    });

    _trainingJudges.forEach((judge) {
      tempMap[judge.id] = judge;
    });

    _combinedJudges = tempMap.values.toList();
    notifyListeners();
  }

  void toggleJudgeAssistance(String judgeId) {
    for (var judge in _combinedJudges) {
      if (judge.id == judgeId) {
        judge.state = judge.state == 'P' ? 'F' : 'P';
        notifyListeners();
        break;
      }
    }
  }

  Future<void> saveJudgesAssistance() async {
    try {
      await _trainingService.addOrUpdateTrainingJudges(
          eventId, trainingId, _combinedJudges);
    } catch (e) {
      print('Error saving training judges: $e');
    }
  }
}
