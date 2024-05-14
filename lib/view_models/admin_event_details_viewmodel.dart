import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/views/selected_judges_view.dart';
import 'package:flutter/material.dart';

import '../views/webview_screen.dart';

class AdminEventDetailsViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();
  Event? _event;
  late String formUrl;

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
