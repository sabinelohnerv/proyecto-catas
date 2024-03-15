import 'package:catas_univalle/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/judge.dart';

class RegisterViewModel with ChangeNotifier {
  final _authService = AuthService();

  String fullName = '';
  String email = '';
  String password = '';
  String birthDate = '';
  String gender = 'M';
  String dislikes = '';
  List<String> symptoms = [];
  bool smokes = true;
  int cigarettesPerDay = 0;
  int coffeeCupsPerDay = 0;
  List<String> seasonings = [];
  int sugarInDrinks = 0;
  List<String> allergies = [];
  String comment = '';

  String _coffee = 'Nunca';
  String get coffee => _coffee;
  set coffee(String newValue) {
    _coffee = newValue;
    notifyListeners();
  }

  String _llajua = 'Nunca';
  String get llajua => _llajua;
  set llajua(String newValue) {
    _llajua = newValue;
    notifyListeners();
  }

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

  List<String> predefinedSeasonings = [
    'Sal',
    'Pimienta',
    'Ajinomoto',
    'Comino',
    'Especias',
    'Ninguno'
  ];

  final List<String> consumptionOptions = [
    'Nunca',
    'Casi nunca',
    'En ocasiones',
    'Frecuentemente',
    'Todos los días'
  ];

  List<String> selectedSymptoms = [];
  List<String> selectedAllergies = [];
  List<String> selectedSeasonings = [];

  TextEditingController birthDateController = TextEditingController();
  TextEditingController symptomsController = TextEditingController();
  TextEditingController allergiesController = TextEditingController();
  TextEditingController seasoningsController = TextEditingController();
  TextEditingController cigarettesPerDayController = TextEditingController();
  TextEditingController coffeeCupsPerDayController = TextEditingController();
  TextEditingController sugarInDrinksController = TextEditingController();

  RegisterViewModel() {
    cigarettesPerDayController.text = cigarettesPerDay.toString();
    coffeeCupsPerDayController.text = coffeeCupsPerDay.toString();
    sugarInDrinksController.text = sugarInDrinks.toString();
  }

  void updateCigarettesPerDay(int value) {
    cigarettesPerDay = value;
    cigarettesPerDayController.text = value.toString();
    notifyListeners();
  }

  void updateCoffeeCupsPerDay(int value) {
    coffeeCupsPerDay = value;
    coffeeCupsPerDayController.text = value.toString();
    notifyListeners();
  }

  void updateSugarInDrinks(int value) {
    sugarInDrinks = value;
    sugarInDrinksController.text = value.toString();
    notifyListeners();
  }

  void selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      final String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      birthDate = formattedDate;
      birthDateController.text = formattedDate;
      notifyListeners();
    }
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

  void updateSymptoms(List<String> newSymptoms) {
    selectedSymptoms = newSymptoms;
    symptomsController.text = selectedSymptoms.join(', ');
    notifyListeners();
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

  void updateAllergies(List<String> newAllergies) {
    selectedAllergies = newAllergies;
    allergiesController.text = selectedAllergies.join(', ');
    notifyListeners();
  }

  void showSeasoningsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Seleccione los condimentos que utiliza',
            style: TextStyle(fontSize: 18),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: ListBody(
                  children: predefinedSeasonings.map((seasoning) {
                    return CheckboxListTile(
                      title: Text(seasoning),
                      value: selectedSeasonings.contains(seasoning),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true &&
                              !selectedSeasonings.contains(seasoning)) {
                            selectedSeasonings.add(seasoning);
                          } else if (value == false) {
                            selectedSeasonings.remove(seasoning);
                          }
                        });
                        updateSeasonings(selectedSeasonings);
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

  void updateSeasonings(List<String> newSeasonings) {
    selectedSeasonings = newSeasonings;
    seasoningsController.text = selectedSeasonings.join(', ');
    notifyListeners();
  }

  bool validateAndSaveForm(GlobalKey<FormState> formKey) {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<bool> register(Judge judge) async {
    try {
      bool registrationSuccess =
          await _authService.judgeRegister(judge, password);
      return registrationSuccess;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
