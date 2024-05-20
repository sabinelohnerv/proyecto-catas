import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/views/judge_training_details_view.dart';
import 'package:flutter/material.dart';

class TrainingsListViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();
  final String event;

  List<Training> _trainings = [];
  List<Training> get trainings => _trainings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TrainingsListViewModel(this.event) {
    listenToEvents();
  }

  void listenToEvents() {
    _isLoading = true;
    notifyListeners();

    _eventService.streamTrainingsForEvent(event).listen((trainingsData) {
      _trainings = trainingsData;
      _isLoading = false;
      notifyListeners();
    });
  }

  void goToTrainingDetailsView(BuildContext context, Training training) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => JudgeTrainingDetailsView(training: training,),
    ));
  }
}
