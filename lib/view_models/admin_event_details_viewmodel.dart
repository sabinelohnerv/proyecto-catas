import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/views/select_judges_view.dart';
import 'package:flutter/material.dart';

class AdminEventDetailsViewModel extends ChangeNotifier {
  void navigateToSelectJudges(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectJudgesView(
          event: event,
        ),
      ),
    );
  }
}
