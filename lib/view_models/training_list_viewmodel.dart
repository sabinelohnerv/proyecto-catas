import 'package:flutter/material.dart';
import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/services/training_service.dart';

class TrainingListViewModel with ChangeNotifier {
  TrainingService _trainingService;
  List<Training> _trainings = [];
  bool _isLoading = false;

  TrainingListViewModel({required TrainingService trainingService})
      : _trainingService = trainingService;

  List<Training> get trainings => _trainings;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> fetchTrainings(String eventId) async {
    setLoading(true);
    try {
      _trainings = await _trainingService.getTrainings(eventId).first;
    } catch (e) {
      print('Error fetching trainings: $e');
      throw e; // Lanzar la excepción para que los consumidores puedan manejarla
    } finally {
      setLoading(false);
    }
  }

  Future<void> addTraining(String eventId, Training training) async {
    setLoading(true);
    try {
      await _trainingService.addTraining(eventId, training);
      _trainings.add(training);
    } catch (e) {
      print('Error adding training: $e');
      throw e;
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateTraining(String eventId, Training training) async {
    setLoading(true);
    try {
      await _trainingService.updateTraining(eventId, training);
      int index = _trainings.indexWhere((t) => t.id == training.id);
      if (index != -1) {
        _trainings[index] = training;
      }
    } catch (e) {
      print('Error updating training: $e');
      throw e;
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteTraining(String eventId, String trainingId) async {
    setLoading(true);
    try {
      await _trainingService.deleteTraining(eventId, trainingId);
      _trainings.removeWhere((t) => t.id == trainingId);
    } catch (e) {
      print('Error deleting training: $e');
      throw e;
    } finally {
      setLoading(false);
    }
  }
}
