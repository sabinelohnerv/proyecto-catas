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
}
