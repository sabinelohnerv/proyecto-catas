import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/view_models/select_judges_viewmodel.dart';
import 'package:flutter/material.dart';

class SelectJudgeCard extends StatelessWidget {
  const SelectJudgeCard({
    super.key,
    required this.context,
    required this.judge,
    required this.isSelected,
    required this.viewModel,
  });

  final BuildContext context;
  final Judge judge;
  final bool isSelected;
  final SelectJudgesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    Color reliabilityColor;

    if (judge.reliability >= 90) {
      reliabilityColor = const Color.fromARGB(255, 97, 160, 117);
    } else if (judge.reliability < 90 && judge.reliability >= 80) {
      reliabilityColor = const Color.fromARGB(255, 175, 225, 175);
    } else if (judge.reliability < 80 && judge.reliability >= 70) {
      reliabilityColor = const Color.fromARGB(255, 251, 238, 132);
    } else if (judge.reliability < 70 && judge.reliability >= 60) {
      reliabilityColor = const Color.fromARGB(255, 244,161,95);
    } else if (judge.reliability < 60 && judge.reliability >= 50) {
      reliabilityColor = const Color.fromARGB(255, 242, 132, 78);
    } else {
      reliabilityColor = const Color.fromARGB(255, 197, 91, 88);
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: screenWidth * 0.06,
          backgroundImage: judge.profileImgUrl.isNotEmpty
              ? NetworkImage(judge.profileImgUrl)
              : null,
          child: judge.profileImgUrl.isEmpty
              ? const Icon(Icons.person_outline)
              : null,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                judge.fullName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.04,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
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
            if (viewModel.missingSelectedJudges.any((j) => j.id == judge.id))
              GestureDetector(
                onTap: () => _showWarningDialog(context),
                child: const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(
                    Icons.warning_amber_outlined,
                    color: Colors.amber,
                    size: 18,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            judge.email,
            style: TextStyle(fontSize: screenWidth * 0.035),
          ),
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

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Juez No Cumple con Criterios",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          "Este juez ha sido rechazado o ya no cumple con los criterios de alergias o síntomas para participar en este evento. \n\n¿Desea mantenerlo seleccionado?",
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text("Retirar Selección"),
                onPressed: () {
                  viewModel.toggleJudgeSelection(judge, false, context);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
