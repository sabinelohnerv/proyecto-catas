import 'package:flutter/foundation.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/models/event_judge.dart';
import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/services/judge_service.dart';
import 'package:flutter/material.dart';

class SelectJudgesViewModel with ChangeNotifier {
  final JudgeService _judgeService = JudgeService();
  final Event event;

  List<Judge> _judges = [];
  List<Judge> get judges => _judges;

  List<EventJudge> _selectedJudges = [];
  List<EventJudge> get selectedJudges => _selectedJudges;

  SelectJudgesViewModel(this.event) {
    fetchJudges();
  }

  Future<void> fetchJudges() async {
    List<Judge> allJudges = await _judgeService.getJudges();
    _judges = allJudges
        .where((judge) => judge.applicationState == 'aprobado')
        .toList();
    if (event.eventJudges != []) {
      _selectedJudges = event.eventJudges
          .where((j) => _judges.any((judge) => judge.id == j.id))
          .toList();
    }
    notifyListeners();
  }

  void toggleJudgeSelection(Judge judge, bool isSelected) {
    if (isSelected) {
      _selectedJudges.add(
        EventJudge(id: judge.id, email: judge.email, state: JudgeState.invited),
      );
    } else {
      _selectedJudges.removeWhere((eventJudge) => eventJudge.id == judge.id);
    }
    notifyListeners();
  }

  void showJudgeDetails(BuildContext context, Judge judge) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(judge.fullName),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Email: ${judge.email}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
