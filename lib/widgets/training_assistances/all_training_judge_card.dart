import 'package:flutter/material.dart';

class AllTrainingJudgeCard extends StatelessWidget {
  const AllTrainingJudgeCard({
    super.key,
    required this.judge,
    required this.number,
    required this.percentage,
  });

  final String judge;
  final int number;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    Color determineColor() {
      Color textColor = Colors.grey;

      if (percentage >= 85) {
        textColor = const Color.fromARGB(255, 97,160,117);
      } else if (percentage < 85 && percentage >= 70) {
        textColor = const Color.fromRGBO(255, 217, 49, 1);
      } else if (percentage < 70 && percentage >= 55) {
        textColor = const Color.fromARGB(255, 244, 161, 95);
      } else {
        textColor = const Color.fromARGB(255, 197, 91, 88);
      }

      return textColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: Text(
          '${number.toString()}.',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        title: Text(judge, style: const TextStyle(fontSize: 16)),
        trailing: Text(
          '${percentage.toStringAsFixed(2)}%',
          style: TextStyle(color: determineColor(), fontSize: 16),
        ),
      ),
    );
  }
}
