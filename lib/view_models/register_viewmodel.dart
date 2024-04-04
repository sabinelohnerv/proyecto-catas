import 'dart:io';

import 'package:catas_univalle/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/judge.dart';
import '../services/user_service.dart';

class RegisterViewModel with ChangeNotifier {
  final _authService = AuthService();
  final _userService = UserService();

  String fullName = '';
  String email = '';
  String password = '';
  String birthDate = '';
  String gender = 'M';
  String dislikes = '';
  List<String> symptoms = [];
  bool smokes = true;
  bool hasTime = true;
  int cigarettesPerDay = 0;
  int coffeeCupsPerDay = 0;
  List<String> seasonings = [];
  int sugarInDrinks = 0;
  List<String> allergies = [];
  String comment = '';

  String _roleAsJudge = 'Estudiante';
  String get roleAsJudge => _roleAsJudge;
  set roleAsJudge(String newValue) {
    _roleAsJudge = newValue;
    notifyListeners();
  }

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

  final List<String> roleOptions = [
    'Estudiante',
    'Docente',
    'Administrativo',
    'Externo',
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

  TextEditingController dislikesController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  RegisterViewModel() {
    cigarettesPerDayController.text = cigarettesPerDay.toString();
    coffeeCupsPerDayController.text = coffeeCupsPerDay.toString();
    sugarInDrinksController.text = sugarInDrinks.toString();
    dislikesController.text = dislikes.toString();
    commentController.text = comment.toString();
  }

  @override
  void dispose() {
    dislikesController.dispose();
    cigarettesPerDayController.dispose();
    coffeeCupsPerDayController.dispose();
    sugarInDrinksController.dispose();
    commentController.dispose();

    super.dispose();
  }

  void resetFields() {
    dislikesController.text = '';
    cigarettesPerDayController.text = '0';
    coffeeCupsPerDayController.text = '0';
    sugarInDrinksController.text = '0';
    commentController.text = '';
  }

  void updateDislikes(String value) {
    dislikes = value;
    dislikesController.text = dislikes.toString();
    notifyListeners();
  }

  void updateSmokes(bool value) {
    smokes = value;
    notifyListeners();
  }

  void updateComment(String value) {
    comment = value;
    notifyListeners();
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

  Future<bool> register(Judge judge, File selectedImage) async {
    try {
      bool registrationSuccess =
          await _authService.judgeRegister(judge, password, selectedImage);
      return registrationSuccess;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //Edit

  Future<void> loadUserProfile() async {
    final currentUser = _userService.getCurrentUser();
    if (currentUser != null) {
      final userDetails = await _userService.getUserDetails(currentUser.uid);
      if (userDetails != null) {
        dislikes = userDetails['dislikes'] ?? '';
        selectedSymptoms = List.from(userDetails['symptoms'] ?? []);
        smokes = userDetails['smokes'] ?? false;
        hasTime = userDetails['hasTime'] ?? false;
        cigarettesPerDay = userDetails['cigarettesPerDay'] ?? 0;
        coffee = userDetails['coffee'] ?? 'Nunca';
        roleAsJudge = userDetails['roleAsJudge'] ?? 'Estudiante';
        coffeeCupsPerDay = userDetails['coffeeCupsPerDay'] ?? 0;
        llajua = userDetails['llajua'] ?? 'Nunca';
        selectedSeasonings = List.from(userDetails['seasonings'] ?? []);
        sugarInDrinks = userDetails['sugarInDrinks'] ?? 0;
        selectedAllergies = List.from(userDetails['allergies'] ?? []);
        comment = userDetails['comment'] ?? '';

        cigarettesPerDayController.text = cigarettesPerDay.toString();
        coffeeCupsPerDayController.text = coffeeCupsPerDay.toString();
        sugarInDrinksController.text = sugarInDrinks.toString();
        dislikesController.text = dislikes.toString();
        commentController.text = comment.toString();

        notifyListeners();
      }
    }
  }

  Future<bool> saveProfileChanges() async {
    final currentUser = _userService.getCurrentUser();
    if (currentUser != null) {
      Judge updatedJudge = Judge(
          id: currentUser.uid,
          fullName: '',
          email: '',
          birthDate: '',
          gender: '',
          dislikes: dislikes,
          symptoms: selectedSymptoms,
          smokes: smokes,
          cigarettesPerDay: cigarettesPerDay,
          coffee: coffee,
          coffeeCupsPerDay: coffeeCupsPerDay,
          llajua: llajua,
          seasonings: selectedSeasonings,
          sugarInDrinks: sugarInDrinks,
          allergies: selectedAllergies,
          comment: comment,
          applicationState: '',
          profileImgUrl: '',
          hasTime: hasTime,
          roleAsJudge: roleAsJudge);
      return await _userService.updateJudgeDetails(updatedJudge);
    }
    return false;
  }
}
