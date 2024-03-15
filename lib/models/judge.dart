class Judge {
  String fullName;
  String email;
  String birthDate;
  String gender;
  String dislikes;
  List<String> symptoms;
  bool smokes;
  int cigarettesPerDay;
  String coffee;
  int coffeeCupsPerDay;
  String llajua;
  List<String> seasonings;
  int sugarInDrinks;
  List<String> allergies;
  String comment;
  String applicationState;

  Judge(
      {required this.fullName,
      required this.email,
      required this.gender,
      required this.birthDate,
      required this.dislikes,
      required this.symptoms,
      required this.smokes,
      required this.cigarettesPerDay,
      required this.coffee,
      required this.coffeeCupsPerDay,
      required this.llajua,
      required this.seasonings,
      required this.sugarInDrinks,
      required this.allergies,
      required this.comment,
      required this.applicationState});
}
