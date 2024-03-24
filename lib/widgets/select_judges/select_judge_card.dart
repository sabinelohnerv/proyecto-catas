import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/view_models/select_judges_viewmodel.dart';
import 'package:flutter/material.dart';

class SelectJudgeCard extends StatelessWidget {
  const SelectJudgeCard(
      {super.key,
      required this.judge,
      required this.isSelected,
      required this.viewModel});

  final Judge judge;
  final bool isSelected;
  final SelectJudgesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: judge.profileImgUrl.isNotEmpty
              ? NetworkImage(judge.profileImgUrl)
              : null,
          child: judge.profileImgUrl.isEmpty
              ? const Icon(Icons.person_outline)
              : null,
        ),
        title: Text(judge.fullName),
        subtitle: Text(judge.email),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (bool? value) {
            if (value != null) {
              viewModel.toggleJudgeSelection(judge, value);
            }
          },
        ),
        onTap: () => viewModel.showJudgeDetails(context, judge),
      ),
    );
  }
}
