import 'package:catas_univalle/models/judge_training_attendance.dart';
import 'package:flutter/material.dart';
import 'package:catas_univalle/models/event_judge.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/services/training_service.dart';

class AllTrainingJudgeAssistanceViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();
  final TrainingService _trainingService = TrainingService();
  final String eventId;

  List<EventJudge> _selectedJudges = [];
  List<JudgeTrainingAttendance> judgeAttendances = [];

  bool _isLoadingEvent = false;
  bool get isLoadingEvent => _isLoadingEvent;

  AllTrainingJudgeAssistanceViewModel(this.eventId) {
    _listenToJudges();
    _calculateAttendance();
  }

  void _listenToJudges() {
    _isLoadingEvent = true;
    notifyListeners();

    _eventService.getSelectedJudgesStream(eventId).listen((selectedJudgesData) {
      _selectedJudges = selectedJudgesData;
      _calculateAttendance();
      _isLoadingEvent = false;
      notifyListeners();
    });
  }

  void _calculateAttendance() {
    _trainingService.getTrainings(eventId).listen((trainings) {
      Map<String, JudgeTrainingAttendance> attendanceMap = {};
      for (final judge in _selectedJudges) {
        attendanceMap[judge.id] =
            JudgeTrainingAttendance(judgeId: judge.id, judgeName: judge.name);
      }

      for (final training in trainings) {
        for (final judge in _selectedJudges) {
          attendanceMap[judge.id]?.totalTrainings += 1;
          if (training.judges.any((trainingJudge) =>
              trainingJudge.id == judge.id && trainingJudge.state == 'P')) {
            attendanceMap[judge.id]?.attendedTrainings += 1;
          }
        }
      }

      judgeAttendances = attendanceMap.values.toList();
      notifyListeners();
    });
  }
}
