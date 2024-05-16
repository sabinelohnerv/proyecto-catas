import 'package:flutter/material.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';

class JudgeEventsViewModel extends ChangeNotifier {
  final String judgeId;
  final EventService _eventService = EventService();
  List<Event> _events = [];
  bool _isLoading = false;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  JudgeEventsViewModel(this.judgeId) {
    loadEventsForJudge();
  }

  Future<void> loadEventsForJudge() async {
    _isLoading = true;
    notifyListeners();
    List<Event> allEvents = await _eventService.fetchEventsForJudge(judgeId);
    _events = allEvents
        .where((event) => event.eventJudges
            .any((judge) => judge.id == judgeId && judge.state == 'accepted'))
        .toList();
    _isLoading = false;
    notifyListeners();
  }
}
