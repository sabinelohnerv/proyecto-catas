enum JudgeState { invited, accepted }

class EventJudge {
  final String id;
  final String email;
  final JudgeState state;

  EventJudge({
    required this.id,
    required this.email,
    required this.state,
  });
}
