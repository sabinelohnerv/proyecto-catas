class JudgeTrainingAttendance {
  final String judgeId;
  final String judgeName;
  int totalTrainings = 0;
  int attendedTrainings = 0;

  double get attendancePercentage => totalTrainings > 0 ? (attendedTrainings / totalTrainings) * 100 : 0;

  JudgeTrainingAttendance({required this.judgeId, required this.judgeName});
}
