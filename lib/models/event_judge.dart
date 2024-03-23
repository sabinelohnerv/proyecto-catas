enum JudgeState { invited, accepted }

class EventJudge {
  final String email; 
  final JudgeState state; 

  EventJudge({
    required this.email,
    required this.state,
  });
}
