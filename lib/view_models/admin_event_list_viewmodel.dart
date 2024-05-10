import 'package:catas_univalle/views/add_event_view.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:flutter/material.dart';

class AdminEventListViewModel with ChangeNotifier {
  final EventService _eventService = EventService();
  List<Event> _events = [];
  List<Event> _filteredEvents = [];
  String _searchQuery = '';

  List<Event> get events => _searchQuery.isEmpty ? _events : _filteredEvents;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AdminEventListViewModel() {
    listenToEvents();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filteredEvents = _events.where((event) {
      return event.name.toLowerCase().contains(query.toLowerCase()) ||
             event.about.toLowerCase().contains(query.toLowerCase());
    }).toList();
    notifyListeners();
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
      if (!_searchQuery.isEmpty) {
        setSearchQuery(_searchQuery);
      }
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
