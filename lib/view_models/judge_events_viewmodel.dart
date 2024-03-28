import 'package:flutter/material.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/models/event.dart';

class JudgeEventsViewModel extends ChangeNotifier {
  final String judgeId;
  final EventService _eventService = EventService();
  List<Event> _events = [];
  bool _isLoading = false;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  JudgeEventsViewModel(this.judgeId) {
    _loadEventsForJudge();
  }

  Future<void> _loadEventsForJudge() async {
    _isLoading = true;
    notifyListeners();
    _events = await _eventService.fetchEventsForJudge(judgeId);
    _isLoading = false;
    notifyListeners();
  }
}
