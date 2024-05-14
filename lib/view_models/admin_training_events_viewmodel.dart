import 'package:catas_univalle/views/training_list_view.dart';
import 'package:flutter/material.dart';
import 'package:catas_univalle/models/event.dart';
import '/services/training_service.dart';
import 'dart:async';

class AdminTrainingEventsViewModel with ChangeNotifier {
  List<Event> _events = [];
  List<Event> _filteredEvents = [];
  Map<String, int> trainingCounts = {};
  bool isLoading = true;
  final TrainingService trainingService;
  StreamSubscription? _subscription;
  String _searchQuery = '';

  List<Event> get events => _searchQuery.isEmpty ? _events : _filteredEvents;

  AdminTrainingEventsViewModel({required this.trainingService}) {
    listenToEventTrainingCounts();
  }

  void listenToEventTrainingCounts() {
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
      print('Error listening to event trainings: $error');
      isLoading = false;
      notifyListeners();
    });
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    filterEvents();
    notifyListeners();
  }

  void filterEvents() {
    _filteredEvents = _events.where((event) {
      return event.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void goToTrainingsListView(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TrainingListView(eventId: event.id, isAdmin: true),
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
