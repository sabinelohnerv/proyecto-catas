import 'dart:async';

import 'package:catas_univalle/services/training_service.dart';
import 'package:flutter/material.dart';
import 'package:catas_univalle/views/training_list_view.dart';
import 'package:catas_univalle/models/event.dart';

class AdminTrainingEventsViewModel with ChangeNotifier {
  List<Event> _events = [];
  Map<String, int> trainingCounts = {};
  bool isLoading = true;
  final TrainingService trainingService;
  StreamSubscription? _subscription;
  String _searchQuery = '';
  String _filterState = 'active';

  AdminTrainingEventsViewModel({required this.trainingService}) {
    _fetchEvents();
  }

  List<Event> get events => _events;
  List<Event> get filteredEvents {
    return _events.where((event) {
      final matchesSearch = event.name.toLowerCase().contains(_searchQuery);
      final matchesFilter =
          _filterState == 'all' || event.state == _filterState;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _fetchEvents() {
    isLoading = true;
    notifyListeners();
    _subscription?.cancel();
    _subscription = trainingService
        .fetchAllEventsWithTrainingCountsStream()
        .listen((eventCounts) {
      _events = eventCounts.keys.toList();
      trainingCounts = eventCounts.map((e, count) => MapEntry(e.id, count));
      isLoading = false;
      notifyListeners();
    }, onError: (error) {
      print('Error fetching events: $error');
      isLoading = false;
      notifyListeners();
    });
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void setFilterState(String state) {
    _filterState = state;
    notifyListeners();
  }

  void goToTrainingsListView(BuildContext context, Event event) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TrainingListView(eventId: event.id, isAdmin: true),
        ));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
