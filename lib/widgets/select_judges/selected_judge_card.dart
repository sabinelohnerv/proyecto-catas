import 'package:catas_univalle/models/event_judge.dart';
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
          textColor = const Color.fromARGB(255, 134, 196, 242);
          stateText = 'Seleccionado';
          break;
        case 'invited':
          textColor = const Color.fromARGB(255, 244, 161, 95);
          stateText = 'Invitado';
          break;
        case 'accepted':
          textColor = const Color.fromARGB(255, 97, 160, 117);
          stateText = 'Confirmado';
          break;
        case 'rejected':
          textColor = const Color.fromARGB(255, 197, 91, 88);
          stateText = 'Rechazado';
          break;
        default:
          textColor = Colors.grey;
          stateText = 'Desconocido';
          break;
      }

      return Text(
        stateText,
        style: TextStyle(color: textColor, fontSize: 14),
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
