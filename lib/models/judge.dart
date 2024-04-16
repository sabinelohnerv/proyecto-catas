import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Judge {
  String id;
  String fullName;
  String email;
  String birthDate;
  String gender;
  String roleAsJudge;
  String dislikes;
  List<String> symptoms;
  bool smokes;
  bool hasTime;
  int cigarettesPerDay;
  String coffee;
  int coffeeCupsPerDay;
  String llajua;
  List<String> seasonings;
  int sugarInDrinks;
  List<String> allergies;
  String comment;
  String applicationState;
  String profileImgUrl;
  double reliability;

  Judge({
    required this.id,
    required this.fullName,
    required this.email,
    required this.gender,
    required this.birthDate,
    required this.roleAsJudge,
    required this.dislikes,
    required this.symptoms,
    required this.smokes,
    required this.hasTime,
    required this.cigarettesPerDay,
    required this.coffee,
    required this.coffeeCupsPerDay,
    required this.llajua,
    required this.seasonings,
    required this.sugarInDrinks,
    required this.allergies,
    required this.comment,
    required this.applicationState,
    required this.profileImgUrl,
    required this.reliability,
  });

  int getAge() {
    DateTime birthDate = _parseDate(this.birthDate);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (birthDate.month > today.month || (birthDate.month == today.month && birthDate.day > today.day)) {
      age--;
    }
    return age;
  }

  DateTime _parseDate(String date) {
    try {
      DateFormat format = DateFormat('dd-MM-yyyy');
      return format.parse(date);
    } catch (e) {
      throw FormatException('Fecha inválida. Asegúrate de que esté en el formato "dd-MM-yyyy".');
    }
  }
}
