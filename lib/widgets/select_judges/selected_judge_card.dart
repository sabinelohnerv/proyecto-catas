import 'package:catas_univalle/models/event_judge.dart';
import 'package:catas_univalle/view_models/select_judges_viewmodel.dart';
import 'package:flutter/material.dart';

class SelectedJudgeCard extends StatelessWidget {
  const SelectedJudgeCard({
    super.key,
    required this.judge,
  });

  final EventJudge judge;

  @override
  Widget build(BuildContext context) {
    Widget determineState() {
      String stateJudge = judge.state;
      Color textColor;
      String stateText;

      switch (stateJudge) {
        case 'selected':
          textColor = Colors.blue;
          stateText = 'Seleccionado';
          break;
        case 'invited':
          textColor = Colors.orange;
          stateText = 'Invitado';
          break;
        case 'confirmed':
          textColor = Colors.green;
          stateText = 'Confirmado';
          break;
        case 'rejected':
          textColor = Colors.red;
          stateText = 'Rechazado';
          break;
        default:
          textColor = Colors.grey;
          stateText = 'Desconocido';
          break;
      }

      return Text(
        stateText,
        style: TextStyle(color: textColor),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              judge.imgUrl.isNotEmpty ? NetworkImage(judge.imgUrl) : null,
          child: judge.imgUrl.isEmpty ? const Icon(Icons.person_outline) : null,
        ),
        title: Text(judge.name),
        subtitle: Text(judge.email),
        trailing: determineState(),
      ),
    );
  }
}
