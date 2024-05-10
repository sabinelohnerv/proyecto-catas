import 'dart:io';
import 'package:catas_univalle/functions/util.dart';
import 'package:catas_univalle/models/client.dart';
import 'package:catas_univalle/models/event_judge.dart';
import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/services/client_service.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEventViewModel with ChangeNotifier {
  final EventService _eventService = EventService();
  final ClientService _clientService = ClientService();

  String? name;
  String? state;
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
  List<Client> clients = [];
  List<EventJudge> eventJudges = [];
  List<Training> trainings = [];

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  TextEditingController locationController = TextEditingController();
  TextEditingController locationUrlController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController numberOfJudgesController = TextEditingController();
  TextEditingController symptomsController = TextEditingController();
  TextEditingController allergiesController = TextEditingController();

  Future<bool> updateEvent(String eventId) async {
    if (!validateInputs()) {
      print('Input validation failed');
      return false;
    }
    setIsSaving(true);
    try {
      String imageUrl = '';
      if (logo != null) {
        imageUrl = await _eventService.uploadEventLogo(
            logo!, "Event_${DateTime.now().millisecondsSinceEpoch}");
      }
      final Event updatedEvent = Event(
        id: eventId,
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
        allergyRestrictions: selectedAllergies,
        symptomRestrictions: selectedSymptoms,
        client: client!,
        numberOfJudges: numberOfJudges!,
        eventJudges: eventJudges,
        trainings: trainings,
        state: state!,
      );
      await _eventService.updateEvent(updatedEvent);
      resetData();
      setIsSaving(false);
      return true;
    } catch (e) {
      print('Error updating event: $e');
      setIsSaving(false);
      return false;
    }
  }

  Future<void> loadEvent(String eventId) async {
    try {
      Event event = await _eventService.fetchEventById(eventId).first;
      fetchClients();
      name = event.name;
      date = event.date;
      start = event.start;
      end = event.end;
      location = event.location;
      locationUrl = event.locationUrl;
      about = event.about;
      formUrl = event.formUrl;
      allergyRestrictions = event.allergyRestrictions;
      symptomRestrictions = event.symptomRestrictions;
      numberOfJudges = event.numberOfJudges;
      state = event.state;
      code = event.code;

      eventJudges = event.eventJudges;
      trainings = event.trainings;

      dateController.text = date ?? '';

      codeController.text = code ?? '';
      nameController.text = name ?? '';
      descriptionController.text = about ?? '';
      numberOfJudgesController.text = numberOfJudges?.toString() ?? '';
      linkController.text = formUrl ?? '';
      locationController.text = location ?? '';
      locationUrlController.text = locationUrl ?? '';

      updateAllergies(allergyRestrictions!);
      updateSymptoms(symptomRestrictions!);

      notifyListeners();
    } catch (e) {
      print('Error loading event: $e');
    }
  }

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

  void selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      startTime = picked;
      start = _formatTimeOfDay(picked);
      startTimeController.text = start!;
      notifyListeners();
    }
  }

  void selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      endTime = picked;
      end = _formatTimeOfDay(picked);
      endTimeController.text = end!;
      notifyListeners();
    }
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.Hm();
    return format.format(dt);
  }

  bool validateTime() {
    if (startTime != null && endTime != null) {
      return startTime!.hour < endTime!.hour ||
          (startTime!.hour == endTime!.hour &&
              startTime!.minute < endTime!.minute);
    }
    return false;
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

  Future<void> fetchClients() async {
    clients = await _clientService.fetchClients();
    notifyListeners();
  }

  void selectClient(Client selectedClient) {
    client = selectedClient;
    notifyListeners();
  }

  Future<bool> addEvent() async {
    if (!validateInputs()) {
      print('could not validate INPUTS');
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
          allergyRestrictions: selectedAllergies,
          symptomRestrictions: selectedSymptoms,
          client: client!,
          numberOfJudges: numberOfJudges!,
          eventJudges: [],
          trainings: [],
          state: 'active');
      await _eventService.addEvent(newEvent);
      setIsSaving(false);
      return true;
    } catch (e) {
      setIsSaving(false);
      print('Error al agregar evento: $e');
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

  void resetData() {
    name = null;
    date = null;
    start = null;
    end = null;
    location = null;
    locationUrl = null;
    about = null;
    logo = null;
    code = null;
    formUrl = null;
    allergyRestrictions = null;
    symptomRestrictions = null;
    client = null;
    numberOfJudges = null;
    judgesEmails = null;

    selectedSymptoms.clear();
    selectedAllergies.clear();
    clients.clear();

    startTime = null;
    endTime = null;
    client = null;

    dateController.clear();
    startTimeController.clear();
    endTimeController.clear();
    codeController.clear();
    numberOfJudgesController.clear();
    symptomsController.clear();
    allergiesController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    client = null;
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    codeController.dispose();
    numberOfJudgesController.dispose();
    symptomsController.dispose();
    allergiesController.dispose();
    super.dispose();
  }
}
