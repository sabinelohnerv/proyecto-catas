import 'package:flutter/material.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';

class JudgeEventsViewModel extends ChangeNotifier {
  final String judgeId;
  final EventService _eventService = EventService();
  List<Event> _events = [];
  List<Event> _filteredEvents = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Event> get events => _searchQuery.isEmpty
      ? _events
          .where((event) => event.eventJudges
              .any((judge) => judge.id == judgeId && judge.state == 'accepted'))
          .toList()
      : _filteredEvents;
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

  void setSearchQuery(String query) {
    _searchQuery = query;
    filterEvents();
    notifyListeners();
  }

  void filterEvents() {
    _filteredEvents = _events.where((event) {
      return event.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.about.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
