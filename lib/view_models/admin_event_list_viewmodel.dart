import 'package:catas_univalle/views/add_event_view.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:flutter/material.dart';

class AdminEventListViewModel with ChangeNotifier {
  final EventService _eventService = EventService();

  List<Event> _events = [];
  List<Event> get events => _events;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AdminEventListViewModel() {
    listenToEvents();
  }

  void setIsLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void listenToEvents() {
    _isLoading = true;
    notifyListeners();

    _eventService.eventsStream().listen((eventData) {
      _events = eventData;
      _isLoading = false;
      notifyListeners();
    });
  }

  void navigateToAddEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEventView()),
    );
  }
}
