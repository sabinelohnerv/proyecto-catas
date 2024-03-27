import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/views/selected_judges_view.dart';
import 'package:flutter/material.dart';

class AdminEventDetailsViewModel extends ChangeNotifier {
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
}
