import 'package:flutter/material.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/views/judge_trainings_list_view.dart';

class JudgeTrainingEventsViewModel extends ChangeNotifier {
  final String judgeId;
  final EventService _eventService = EventService();
  List<Event> _events = [];
  List<Event> _filteredEvents = [];
  bool _isLoading = false;
  Map<String, int> _trainingCounts = {};
  String _searchQuery = '';

  List<Event> get events => _events;
  List<Event> get filteredEvents => _filteredEvents;
  bool get isLoading => _isLoading;
  Map<String, int> get trainingCounts => _trainingCounts;

  JudgeTrainingEventsViewModel(this.judgeId) {
    loadTrainingEventsForJudge();
  }

  Future<void> loadTrainingEventsForJudge() async {
    _isLoading = true;
    notifyListeners();
    List<Event> allEvents = await _eventService.fetchEventsForJudge(judgeId);
    _events = allEvents
        .where((event) => event.eventJudges
            .any((judge) => judge.id == judgeId && judge.state == 'accepted'))
        .toList();
    _isLoading = false;
    _filterEvents(); 
    notifyListeners();
    await _fetchTrainingCounts();
  }

  Future<void> _fetchTrainingCounts() async {
    for (var event in _events) {
      _trainingCounts[event.id] =
          await _eventService.countTrainingsForEvent(event.id);
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterEvents();
  }

  void _filterEvents() {
    if (_searchQuery.isEmpty) {
      _filteredEvents = _events;
    } else {
      _filteredEvents = _events.where((event) {
        return event.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void goToTrainingsListView(BuildContext context, Event event) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TrainingsListView(event: event),
    ));
  }
}
