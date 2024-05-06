import 'package:catas_univalle/views/training_list_view.dart';
import 'package:flutter/material.dart';
import 'package:catas_univalle/models/event.dart';
import '/services/training_service.dart';
import 'dart:async';

class AdminTrainingEventsViewModel with ChangeNotifier {
  List<Event> events = [];
  Map<String, int> trainingCounts = {};
  bool isLoading = true;
  final TrainingService trainingService;
  StreamSubscription? _subscription;

  AdminTrainingEventsViewModel({required this.trainingService}) {
    listenToEventTrainingCounts();
  }

  void listenToEventTrainingCounts() {
    isLoading = true;
    notifyListeners();
    _subscription?.cancel();
    _subscription = trainingService.fetchAllEventsWithTrainingCountsStream().listen(
      (eventCounts) {
        events = eventCounts.keys.toList();
        trainingCounts = eventCounts.map((e, count) => MapEntry(e.id, count));
        isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        print('Error listening to event trainings: $error');
        isLoading = false;
        notifyListeners();
      }
    );
  }

  void goToTrainingsListView(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainingListView(eventId: event.id, isAdmin: true),
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
