import 'dart:io';
import 'package:flutter/material.dart';
import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/services/training_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AdminTrainingEditViewModel extends ChangeNotifier {
  final TrainingService _trainingService = TrainingService();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  bool _isLoading = false;
  bool _isDisposed = false;
  bool _isUploading = false; // Add this line
  String? _pdfUrl;

  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading; // Add this line
  String? get pdfUrl => _pdfUrl;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void setLoading(bool loading) {
    if (_isDisposed) return;
    _isLoading = loading;
    notifyListeners();
  }

  void setUploading(bool uploading) {
    // Add this method
    if (_isDisposed) return;
    _isUploading = uploading;
    notifyListeners();
  }

  Future<Training> updateTraining(String eventId, Training training) async {
    setLoading(true);
    try {
      if (_pdfUrl != null && _pdfUrl != training.pdfUrl) {
        training.pdfUrl = _pdfUrl;
      }
      await _trainingService.updateTraining(eventId, training);
    } catch (e) {
      print('Error updating training: $e');
      if (!_isDisposed) {
        setLoading(false);
      }
      throw e;
    }
    if (!_isDisposed) {
      setLoading(false);
      return training;
    } else {
      throw Exception('ViewModel has been disposed');
    }
  }

  Future<void> uploadPDF(File file) async {
    setUploading(true); // Update this line
    try {
      String fileName = file.path.split('/').last;
      String filePath = 'pdfs/$fileName';
      firebase_storage.UploadTask uploadTask =
          storage.ref().child(filePath).putFile(file);
      firebase_storage.TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      _pdfUrl = downloadUrl;
      notifyListeners();
    } catch (e) {
      print('Error uploading PDF: $e');
      _pdfUrl = null;
    } finally {
      if (!_isDisposed) {
        setUploading(false); // Update this line
      }
    }
  }
}
