import 'dart:async';

import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/models/event_judge.dart';
import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/services/judge_service.dart';
import 'package:catas_univalle/widgets/select_judges/judge_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class SelectJudgesViewModel with ChangeNotifier {
  final JudgeService _judgeService = JudgeService();
  final EventService _eventService = EventService();

  Event? _event;
  Event? get event => _event;

  String _eventId;
  List<Judge> _judges = [];
  List<Judge> get judges => _judges;

  final _selectedJudgesController =
      StreamController<List<EventJudge>>.broadcast();
  Stream<List<EventJudge>> get selectedJudgesStream =>
      _selectedJudgesController.stream;

  List<EventJudge> _selectedJudges = [];
  List<EventJudge> get selectedJudges => _selectedJudges;

  SelectJudgesViewModel(this._eventId) {
    initialize();
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
    notifyListeners();
  }

  Future<void> initialize() async {
    try {
      _event = await _eventService.fetchEventById(_eventId).first;
      if (_event != null) {
        await fetchJudges();
      }
    } catch (e) {
      return;
    }
    notifyListeners();
  }

  Future<void> fetchJudges() async {
    if (_event == null) return;

    List<Judge> allJudges = await _judgeService.getJudges();

    List<Judge> approvedJudges = allJudges
        .where((judge) => judge.applicationState == 'aprobado')
        .toList();

    List<Judge> filteredByAllergies =
        _event!.allergyRestrictions.contains('Ninguna')
            ? approvedJudges
            : approvedJudges
                .where((judge) => !judge.allergies.any(
                    (allergy) => _event!.allergyRestrictions.contains(allergy)))
                .toList();

    List<Judge> filteredJudges = _event!.symptomRestrictions.contains('Ninguno')
        ? filteredByAllergies
        : filteredByAllergies
            .where((judge) => !judge.symptoms.any(
                (symptom) => _event!.symptomRestrictions.contains(symptom)))
            .toList();

    _judges = filteredJudges;

    _selectedJudges.clear();
    for (var judge in _judges) {
      if (_event!.eventJudges.any((eJudge) => eJudge.id == judge.id)) {
        _selectedJudges.add(
            _event!.eventJudges.firstWhere((eJudge) => eJudge.id == judge.id));
      }
    }

    _selectedJudgesController.sink.add(_selectedJudges);

    notifyListeners();
  }

  void toggleJudgeSelection(
      Judge judge, bool isSelected, BuildContext context) {
    if (isSelected) {
      if (_selectedJudges.length < _event!.numberOfJudges) {
        final existingJudge = _event!.eventJudges.firstWhereOrNull(
          (eJudge) => eJudge.id == judge.id && (eJudge.state == 'invited' || eJudge.state == 'accepted' || eJudge.state == 'rejected'),
        );

        if (existingJudge != null) {
          if (!_selectedJudges.any((eJudge) => eJudge.id == judge.id)) {
            _selectedJudges.add(existingJudge);
          }
        } else {
          _selectedJudges.add(
            EventJudge(
                id: judge.id,
                email: judge.email,
                state: 'selected',
                imgUrl: judge.profileImgUrl,
                name: judge.fullName),
          );
        }

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
    if (_event == null) return;

    try {
      await _eventService.addOrUpdateSelectedJudges(
          _event!.id, _selectedJudges);
    } catch (e) {
      print('Error saving selected judges: $e');
    }
  }

  void showJudgeDetails(BuildContext context, Judge judge) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: JudgeDetailCard(judge: judge),
      ),
    );
  }
}
