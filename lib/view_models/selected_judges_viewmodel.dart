import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/views/select_judges_view.dart';
import 'package:flutter/material.dart';
import 'package:catas_univalle/models/event_judge.dart';
import 'package:catas_univalle/services/event_service.dart';

class SelectedJudgesViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();
  final Event event;

  Stream<List<EventJudge>>? selectedJudgesStream;

  SelectedJudgesViewModel(this.event) {
    _loadSelectedJudges();
  }

  void _loadSelectedJudges() {
    selectedJudgesStream = _eventService.getSelectedJudgesStream(event.id);
    notifyListeners();
  }

  void navigateToSelectJudges(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectJudgesView(
          eventId: event.id,
        ),
      ),
    );
  }
}
