import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/views/selected_judges_view.dart';
import 'package:catas_univalle/views/edit_event_view.dart';
import 'package:flutter/material.dart';

import '../views/webview_screen.dart';

class AdminEventDetailsViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();
  Event? _event;
  late String formUrl;

  Event? get event => _event;

  Stream<Event> getEventStream(String eventId) {
    return _eventService.fetchEventById(eventId);
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

  void navigateToForm(BuildContext context, String formUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          formUrl: formUrl,
        ),
      ),
    );
  }

  Future<void> navigateToEditEvent(BuildContext context, String eventId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventView(eventId: eventId),
      ),
    );
  }

  Future<bool> deleteCurrentEvent(BuildContext context, String eventId) async {
    try {
      await _eventService.deleteEvent(eventId);
      Navigator.of(context).pop();
      return true;
    } catch (e) {
      print("Error deleting event: $e");
      return false;
    }
  }
}
