import 'package:flutter/material.dart';
import '/models/event.dart';
import '/services/event_service.dart';

class CataEventsViewModel with ChangeNotifier {
  List<Event> _cataEvents = [];
  final EventService _eventService = EventService();

  List<Event> get cataEvents => _cataEvents;

  CataEventsViewModel() {
    loadCataEvents();
  }

  Future<void> loadCataEvents() async {
    _cataEvents = await _eventService.fetchAllCataEvents();
    notifyListeners();
  }
}
