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
    // Si deseas comenzar a escuchar inmediatamente, podrías llamar a subscribeToTrainings aquí
  }

  List<Training> get trainings => _trainings;
  bool get isLoading => _isLoading;

  void subscribeToTrainings(String eventId) {
    setLoading(true);
    _trainingsSubscription?.cancel(); // Cancela cualquier subscripción existente
    _trainingsSubscription = _trainingService.getTrainings(eventId).listen(
      (trainingsList) {
        _trainings = trainingsList;
        setLoading(false);
      },
      onError: (error) {
        print('Error listening to trainings: $error');
        setLoading(false);
      }
    );
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    _trainingsSubscription?.cancel(); // Limpieza al deshacerse del ViewModel
    super.dispose();
  }
}
