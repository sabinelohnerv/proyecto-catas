import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/views/selected_judges_view.dart';
import 'package:flutter/material.dart';

class AdminEventDetailsViewModel extends ChangeNotifier {
  EventService _eventService = EventService();
  Event? _event;

  Event? get event => _event;

  void loadEventDetails(Event event) {
    _event = event;
    notifyListeners();
  }

  void navigateToSelectedJudges(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectedJudgesView(
          event: event,
        ),
      ),
    );
  }

  Future<bool> deleteCurrentEvent(BuildContext context, String eventId) async {
    try {
      await _eventService.deleteEvent(eventId);
      return true;
    } catch (e) {
      print("Error deleting event: $e");
      return false;
    }
  }
}
