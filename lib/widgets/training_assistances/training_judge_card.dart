import 'package:catas_univalle/models/event_judge.dart';
import 'package:flutter/material.dart';

class TrainingJudgeCard extends StatelessWidget {
  const TrainingJudgeCard({
    super.key,
    required this.judge,
    required this.number,
  });

  final EventJudge judge;
  final int number;

  @override
  Widget build(BuildContext context) {
    Widget determineState() {
      String stateJudge = judge.state;
      Color textColor;
      String stateText;

      switch (stateJudge) {
        case 'P':
          textColor = Colors.green;
          stateText = 'P';
          break;
        case 'F':
          textColor = Colors.red;
          stateText = 'F';
          break;
        default:
          textColor = Colors.grey;
          stateText = 'Desconocido';
          break;
      }

      return Text(
        stateText,
        style: TextStyle(color: textColor, fontSize: 16),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: Text('${number.toString()}.', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
        title: Text(judge.name, style: const TextStyle(fontSize: 16)),
        trailing: determineState(),
      ),
    );
  }
}