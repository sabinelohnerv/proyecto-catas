import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/view_models/select_judges_viewmodel.dart';
import 'package:flutter/material.dart';

class SelectJudgeCard extends StatelessWidget {
  const SelectJudgeCard(
      {super.key,
      required this.context,
      required this.judge,
      required this.isSelected,
      required this.viewModel});

  final BuildContext context;
  final Judge judge;
  final bool isSelected;
  final SelectJudgesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    Color reliabilityColor;

    if (judge.reliability >= 90) {
      reliabilityColor = Colors.green;
    } else if (judge.reliability < 90 && judge.reliability >= 80) {
      reliabilityColor = Colors.lightGreen;
    } else if (judge.reliability < 80 && judge.reliability >= 70) {
      reliabilityColor = Colors.yellow.shade400;
    } else if (judge.reliability < 70 && judge.reliability >= 60) {
      reliabilityColor = Colors.amber;
    } else if (judge.reliability < 60 && judge.reliability >= 50) {
      reliabilityColor = Colors.orange;
    } else {
      reliabilityColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: judge.profileImgUrl.isNotEmpty
              ? NetworkImage(judge.profileImgUrl)
              : null,
          child: judge.profileImgUrl.isEmpty
              ? const Icon(Icons.person_outline)
              : null,
        ),
        title: Row(
          children: [
            Text(judge.fullName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
            const SizedBox(width: 10,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: reliabilityColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${judge.reliability.toString()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(judge.email),
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (bool? value) {
            if (value != null) {
              viewModel.toggleJudgeSelection(judge, value, context);
            }
          },
        ),
        onTap: () => viewModel.showJudgeDetails(context, judge),
      ),
    );
  }
}
