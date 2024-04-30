import 'package:catas_univalle/views/training_list_view.dart';
import 'package:flutter/material.dart';
import 'package:catas_univalle/models/event.dart';
import '/services/training_service.dart';

class AdminTrainingEventsViewModel with ChangeNotifier {
  List<Event> events = [];
  Map<String, int> trainingCounts = {};
  bool isLoading = true;
  final TrainingService _trainingService = TrainingService();

  AdminTrainingEventsViewModel() {
    loadAllTrainings();
  }

  void loadAllTrainings() async {
    isLoading = true;
    notifyListeners();
    try {
      Map<Event, int> fetchedEvents =
          await _trainingService.fetchAllEventsWithTrainings();
      events = fetchedEvents.keys.toList();
      trainingCounts =
          fetchedEvents.map((event, count) => MapEntry(event.id, count));
    } catch (e) {
      print('Error fetching events with trainings: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void listenToEventTrainingCounts() {
  isLoading = true;
  notifyListeners();
  _trainingService.fetchAllEventsWithTrainingCountsStream().listen((eventCounts) {
    events = eventCounts.keys.toList();
    trainingCounts = eventCounts.cast<String, int>();
    isLoading = false;
    notifyListeners();
  }, onError: (error) {
    print('Error listening to event trainings: $error');
    isLoading = false;
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
}
