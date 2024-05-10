import 'dart:async';
import 'package:flutter/material.dart';
import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/services/training_service.dart';

class TrainingListViewModel with ChangeNotifier {
  late TrainingService _trainingService;
  List<Training> _trainings = [];
  bool _isLoading = false;
  StreamSubscription? _trainingsSubscription;

  TrainingListViewModel({required TrainingService trainingService}) {
    _trainingService = trainingService;
  }

  List<Training> get trainings => _trainings;
  bool get isLoading => _isLoading;

  void subscribeToTrainings(String eventId) {
    setLoading(true);
    _trainingsSubscription?.cancel();
    _trainingsSubscription =
        _trainingService.getTrainings(eventId).listen((trainingsList) {
      _trainings = trainingsList;
      setLoading(false);
    }, onError: (error) {
      print('Error listening to trainings: $error');
      setLoading(false);
    });
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void deleteTraining(String eventId, String trainingId) {
    _trainingService.deleteTraining(eventId, trainingId).then((_) {
      _trainings.removeWhere((training) => training.id == trainingId);
      notifyListeners();
    }).catchError((error) {
      print("Error deleting training: $error");
    });
  }

  @override
  void dispose() {
    _trainingsSubscription?.cancel(); 
    super.dispose();
  }
}
