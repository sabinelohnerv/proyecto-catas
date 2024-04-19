import 'package:flutter/material.dart';
import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/services/training_service.dart';

class TrainingViewModel with ChangeNotifier {
  TrainingService _trainingService; // Hazlo mutable, no final

  List<Training> _trainings = [];
  bool _isLoading = false;

  TrainingViewModel({required TrainingService trainingService})
      : _trainingService = trainingService;

  List<Training> get trainings => _trainings;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> addTraining(String eventId, Training training) async {
    setLoading(true);
    try {
      await _trainingService.addTraining(eventId, training);
    } catch (e) {
      setLoading(false);
      rethrow;
    }
    setLoading(false);
  }

  Future<void> updateTraining(String eventId, Training training) async {
    setLoading(true);
    try {
      await _trainingService.updateTraining(eventId, training);
    } catch (e) {
      setLoading(false);
      rethrow;
    }
    setLoading(false);
  }

  Future<void> deleteTraining(String eventId, String trainingId) async {
    setLoading(true);
    try {
      await _trainingService.deleteTraining(eventId, trainingId);
    } catch (e) {
      setLoading(false);
      rethrow;
    }
    setLoading(false);
  }

  void loadTrainings(String eventId) {
    setLoading(true);
    _trainingService.getTrainings(eventId).listen((trainingList) {
      _trainings = trainingList;
      setLoading(false);
      notifyListeners();
    });
  }

  void updateTrainingService(TrainingService trainingService) {
    _trainingService = trainingService;
  }

  Future<void> fetchTrainings(String eventId) async {
    if (eventId.isEmpty) {
      print('Error fetching trainings: eventId is empty');
      return;  // Salir temprano si no hay un eventId válido
    }

    setLoading(true);
    try {
      _trainings = await _trainingService.getTrainings(eventId).first;
    } catch (e) {
      print('Error fetching trainings: $e');
      throw e;  // Lanzar la excepción para que los consumidores puedan manejarla
    } finally {
      setLoading(false);
    }
  }
}
