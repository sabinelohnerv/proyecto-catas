import 'dart:async';
import 'dart:math';

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

  List<Judge> _missingSelectedJudges = [];
  List<Judge> get missingSelectedJudges => _missingSelectedJudges;

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

    _missingSelectedJudges = allJudges.where((judge) {
      bool isInEventJudges =
          _event!.eventJudges.any((eJudge) => eJudge.id == judge.id);
      bool isNotInFilteredJudges =
          !_judges.any((fJudge) => fJudge.id == judge.id);
      bool isNotInSelectedJudges =
          !_selectedJudges.any((sJudge) => sJudge.id == judge.id);
      return isInEventJudges && isNotInFilteredJudges && isNotInSelectedJudges;
    }).toList();

    _selectedJudges.addAll(missingSelectedJudges.map((judge) => EventJudge(
        id: judge.id,
        email: judge.email,
        fcmToken: judge.fcmToken,
        state: 'warning',
        imgUrl: judge.profileImgUrl,
        name: judge.fullName,
        gender: judge.gender)));

    _judges.addAll(missingSelectedJudges);

    _selectedJudgesController.sink.add(_selectedJudges);

    notifyListeners();
  }

  void toggleJudgeSelection(
      Judge judge, bool isSelected, BuildContext context) {
    if (isSelected) {
      if (_selectedJudges.length < _event!.numberOfJudges) {
        final existingJudge = _event!.eventJudges.firstWhereOrNull(
          (eJudge) =>
              eJudge.id == judge.id &&
              (eJudge.state == 'invited' ||
                  eJudge.state == 'accepted' ||
                  eJudge.state == 'rejected'),
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
                fcmToken: judge.fcmToken,
                state: 'selected',
                imgUrl: judge.profileImgUrl,
                name: judge.fullName,
                gender: judge.gender),
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

  Future<void> randomSelectJudges(int numJudges) async {
    if (_event == null || numJudges > _judges.length || numJudges <= 0) {
      return;
    }

    final alreadySelectedJudges =
        _selectedJudges.map((eJudge) => eJudge.id).toList();

    final maleSelectedCount =
        _selectedJudges.where((j) => j.gender == 'M').length;
    final femaleSelectedCount =
        _selectedJudges.where((j) => j.gender == 'F').length;

    final maleJudges = _judges
        .where((judge) =>
            judge.gender == 'M' && !alreadySelectedJudges.contains(judge.id))
        .toList();
    final femaleJudges = _judges
        .where((judge) =>
            judge.gender == 'F' && !alreadySelectedJudges.contains(judge.id))
        .toList();

    final targetMaleJudges = (numJudges / 2).ceil() - maleSelectedCount;
    final targetFemaleJudges =
        numJudges - targetMaleJudges - femaleSelectedCount;

    final selectedJudges = [..._selectedJudges];

    while (selectedJudges.length < _event!.numberOfJudges) {
      Judge? selectedJudge;
      if (selectedJudges.length - _selectedJudges.length < targetMaleJudges) {
        selectedJudge = _getRandomJudge(maleJudges, sortByReliability: true);
      } else if (selectedJudges.length - _selectedJudges.length < numJudges) {
        selectedJudge = _getRandomJudge(femaleJudges, sortByReliability: true);
      }

      if (selectedJudge != null) {
        selectedJudges.add(EventJudge(
            id: selectedJudge.id,
            email: selectedJudge.email,
            fcmToken: selectedJudge.fcmToken,
            state: 'selected',
            imgUrl: selectedJudge.profileImgUrl,
            name: selectedJudge.fullName,
            gender: selectedJudge.gender));
      } else {
        break;
      }
    }

    _selectedJudges = selectedJudges;
    _selectedJudgesController.sink.add(_selectedJudges);
    notifyListeners();
  }

  Judge? _getRandomJudge(List<Judge> judges, {bool sortByReliability = false}) {
    if (judges.isEmpty) return null;

    if (sortByReliability) {
      judges.sort((a, b) => b.reliability.compareTo(a.reliability));
    }

    final weights = judges.map((judge) => judge.reliability).toList();
    final totalWeight = weights.reduce((a, b) => a + b);

    final randomValue = Random().nextDouble() * totalWeight;
    var currentWeight = 0.0;
    for (var i = 0; i < judges.length; i++) {
      currentWeight += weights[i];
      if (randomValue <= currentWeight) {
        return judges[i];
      }
    }
    return judges.last;
  }

  void deselectAllJudges() {
    _selectedJudges.clear();
    _selectedJudgesController.sink.add(_selectedJudges);
    notifyListeners();
  }
}
