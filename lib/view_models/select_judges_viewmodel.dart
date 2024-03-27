import 'dart:async';

import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/models/event_judge.dart';
import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/services/judge_service.dart';
import 'package:flutter/material.dart';

class SelectJudgesViewModel with ChangeNotifier {
  final JudgeService _judgeService = JudgeService();
  final EventService _eventService = EventService();

  final Event event;

  List<Judge> _judges = [];
  List<Judge> get judges => _judges;

  final _selectedJudgesController =
      StreamController<List<EventJudge>>.broadcast();
  Stream<List<EventJudge>> get selectedJudgesStream =>
      _selectedJudgesController.stream;

  List<EventJudge> _selectedJudges = [];
  List<EventJudge> get selectedJudges => _selectedJudges;

  SelectJudgesViewModel(this.event) {
    fetchJudges();
  }

  @override
  void dispose() {
    _selectedJudgesController.close();
    _selectedJudges.clear();
    super.dispose();
  }

  void resetData() {
    _judges.clear();
    _selectedJudges.clear();
  }

  Future<void> fetchJudges() async {
    List<Judge> allJudges = await _judgeService.getJudges();

    List<Judge> approvedJudges = allJudges
        .where((judge) => judge.applicationState == 'aprobado')
        .toList();

    List<Judge> filteredByAllergies = event.allergyRestrictions
            .contains('Ninguna')
        ? approvedJudges
        : approvedJudges
            .where((judge) => !judge.allergies
                .any((allergy) => event.allergyRestrictions.contains(allergy)))
            .toList();

    List<Judge> filteredJudges = event.symptomRestrictions.contains('Ninguno')
        ? filteredByAllergies
        : filteredByAllergies
            .where((judge) => !judge.symptoms
                .any((symptom) => event.symptomRestrictions.contains(symptom)))
            .toList();

    _judges = filteredJudges;

    _selectedJudges.clear();
    for (var judge in _judges) {
      if (event.eventJudges.any((eJudge) => eJudge.id == judge.id)) {
        _selectedJudges.add(
            event.eventJudges.firstWhere((eJudge) => eJudge.id == judge.id));
      }
    }

    _selectedJudgesController.sink.add(_selectedJudges);

    notifyListeners();
  }

  void toggleJudgeSelection(
      Judge judge, bool isSelected, BuildContext context) {
    if (isSelected) {
      if (_selectedJudges.length < event.numberOfJudges) {
        _selectedJudges.add(
          EventJudge(
              id: judge.id,
              email: judge.email,
              state: 'selected',
              imgUrl: judge.profileImgUrl,
              name: judge.fullName),
        );
        _selectedJudgesController.sink.add(_selectedJudges);
      } else {
        _showMaxJudgesSelectedMessage(context);
      }
    } else {
      _selectedJudges.removeWhere((eventJudge) => eventJudge.id == judge.id);
      _selectedJudgesController.sink.add(_selectedJudges);
    }
    notifyListeners();
  }

  void _showMaxJudgesSelectedMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cantidad de Jueces Alcanzada"),
        content: const Text("Has alcanzado la cantidad de jueces máxima."),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> saveSelectedJudges() async {
    try {
      await _eventService.addOrUpdateSelectedJudges(event.id, _selectedJudges);
    } catch (e) {
      print('Error saving selected judges: $e');
    }
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
