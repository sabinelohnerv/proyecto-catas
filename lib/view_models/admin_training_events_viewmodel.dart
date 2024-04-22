import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/views/training_list_view.dart';
import 'package:flutter/material.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';
import '/services/training_service.dart';

class AdminTrainingEventsViewModel with ChangeNotifier {
  List<Event> _events = [];
  Map<String, int> _trainingCounts = {};
  bool _isLoading = true;

  AdminTrainingEventsViewModel() {
    loadAllTrainings();
  }

  List<Event> get events => _events;
  Map<String, int> get trainingCounts => _trainingCounts;
  bool get isLoading => _isLoading;

  Future<void> loadAllTrainings() async {
    _isLoading = true;
    notifyListeners();
    var results = await TrainingService().fetchAllEventsWithTrainings(); 
    _events = results.keys.toList();
    _trainingCounts = results.cast<String, int>();
    _isLoading = false;
    notifyListeners();
  }

  void goToTrainingsListView(BuildContext context, Event event) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TrainingListView(eventId: event.id, isAdmin: true),
    ),
  );
}

}
