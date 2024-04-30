import 'package:catas_univalle/models/event_judge.dart';
import 'package:flutter/material.dart';

class TrainingAssistanceCard extends StatelessWidget {
  const TrainingAssistanceCard({
    super.key,
    required this.judge,
    required this.number,
    required this.onStateToggle,
  });

  final EventJudge judge;
  final int number;
  final Function(EventJudge) onStateToggle;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: Text('$number.',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        title: Text(judge.name, style: const TextStyle(fontSize: 16)),
        trailing: Checkbox(
          value: judge.state == 'P',
          onChanged: (bool? value) {
            onStateToggle(judge);
          },
        ),
      ),
    );
  }
}
