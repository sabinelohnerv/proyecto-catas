import 'dart:io';
import 'package:catas_univalle/functions/util.dart';
import 'package:catas_univalle/models/client.dart';
import 'package:flutter/foundation.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEventViewModel with ChangeNotifier {
  final EventService _eventService = EventService();

  String? name;
  String? date;
  String? start;
  String? end;
  String? location;
  String? locationUrl;
  String? about;
  File? logo;
  String? code;
  String? formUrl;
  List<String>? allergyRestrictions;
  List<String>? symptomRestrictions;
  Client? client;
  int? numberOfJudges;
  List<String>? judgesEmails;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  List<String> predefinedSymptoms = [
    'Alergias',
    'Resfrío crónico o sinusitis',
    'Diabetes',
    'Tratamiento dental',
    'Asma',
    'Gastritis',
    'Ninguno'
  ];

  List<String> predefinedAllergies = [
    'Maní',
    'Frutos secos',
    'Lácteos',
    'Gluten',
    'Conservantes',
    'Mariscos crustáceos',
    'Soja',
    'Ninguna'
  ];

  List<String> selectedSymptoms = [];
  List<String> selectedAllergies = [];

  TextEditingController dateController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController numberOfJudgesController = TextEditingController();
  TextEditingController symptomsController = TextEditingController();
  TextEditingController allergiesController = TextEditingController();

  void setIsSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != DateTime.now()) {
      final String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      date = formattedDate;
      dateController.text = formattedDate;
      notifyListeners();
    }
  }

  void randomizeCode() {
    String randomCode = generateRandomCode();
    code = randomCode;
    codeController.text = randomCode;
    notifyListeners();
  }

  void updateNumberOfJudges(int value) {
    numberOfJudges = value;
    numberOfJudgesController.text = value.toString();
    notifyListeners();
  }

  void showSymptomsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '¿Padece alguno o algunos de estos síntomas o realiza alguno(s) tratamientos?',
            style: TextStyle(fontSize: 18),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: ListBody(
                  children: predefinedSymptoms.map((symptom) {
                    return CheckboxListTile(
                      title: Text(symptom),
                      value: selectedSymptoms.contains(symptom),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true &&
                              !selectedSymptoms.contains(symptom)) {
                            selectedSymptoms.add(symptom);
                          } else if (value == false) {
                            selectedSymptoms.remove(symptom);
                          }
                        });
                        updateSymptoms(selectedSymptoms);
                      },
                    );
                  }).toList(),
                ),
              );
            },
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

  void showAllergiesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '¿Tiene alguna alergia o intolerancia?',
            style: TextStyle(fontSize: 18),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: ListBody(
                  children: predefinedAllergies.map((allergy) {
                    return CheckboxListTile(
                      title: Text(allergy),
                      value: selectedAllergies.contains(allergy),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true &&
                              !selectedAllergies.contains(allergy)) {
                            selectedAllergies.add(allergy);
                          } else if (value == false) {
                            selectedAllergies.remove(allergy);
                          }
                        });
                        updateAllergies(selectedAllergies);
                      },
                    );
                  }).toList(),
                ),
              );
            },
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

  void updateSymptoms(List<String> newSymptoms) {
    selectedSymptoms = newSymptoms;
    symptomsController.text = selectedSymptoms.join(', ');
    notifyListeners();
  }

  void updateAllergies(List<String> newAllergies) {
    selectedAllergies = newAllergies;
    allergiesController.text = selectedAllergies.join(', ');
    notifyListeners();
  }

  Future<bool> addEvent() async {
    if (!validateInputs()) {
      return false;
    }
    setIsSaving(true);
    try {
      String imageUrl = '';
      if (logo != null) {
        imageUrl = await _eventService.uploadEventLogo(
            logo!, "Event_${DateTime.now().millisecondsSinceEpoch}");
      }
      final Event newEvent = Event(
        id: "Event_${DateTime.now().millisecondsSinceEpoch}",
        name: name!,
        date: date!,
        start: start!,
        end: end!,
        location: location!,
        locationUrl: locationUrl!,
        about: about!,
        imageUrl: imageUrl,
        code: code!,
        formUrl: formUrl!,
        allergyRestrictions: allergyRestrictions!,
        symptomRestrictions: symptomRestrictions!,
        client: client!,
        numberOfJudges: numberOfJudges!,
        judgesEmails: judgesEmails!,
      );
      await _eventService.addEvent(newEvent);
      setIsSaving(false);
      return true;
    } catch (e) {
      setIsSaving(false);
      return false;
    }
  }

  bool validateInputs() {
    return name != null &&
        date != null &&
        start != null &&
        end != null &&
        location != null &&
        about != null &&
        client != null &&
        numberOfJudges != null;
  }
}
