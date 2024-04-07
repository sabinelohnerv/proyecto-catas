import 'package:flutter/material.dart';
import 'package:catas_univalle/models/judge.dart';

class JudgeDetailCard extends StatelessWidget {
  final Judge judge;

  const JudgeDetailCard({super.key, required this.judge});

  @override
  Widget build(BuildContext context) {
    String seasoningsString = judge.seasonings.join(', ');
    String smokesString = judge.smokes ? 'Sí' : 'No';
    String timeString = judge.hasTime ? 'Sí' : 'No';

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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(judge.profileImgUrl),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  judge.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 6,),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
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
            Text(
              judge.email,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            _infoText('Fecha de Nacimiento:', judge.birthDate),
            _infoText(
                'Género:', judge.gender == 'F' ? 'Femenino' : 'Masculino'),
            _infoText('Rol en la institución:', judge.roleAsJudge),
            _infoText('Tiempo disponible:', timeString),
            _infoText('Fumador:', smokesString),
            if (judge.smokes)
              _infoText('Cigarillos por día:', '${judge.cigarettesPerDay}'),
            _infoText('Café:', judge.coffee),
            if (judge.coffee.toLowerCase() != 'nunca')
              _infoText('Tazas de café al día:', '${judge.coffeeCupsPerDay}'),
            _infoText('Picante o Llajua:', judge.llajua),
            _infoText(
                'Azúcar en Bebidas:',
                judge.sugarInDrinks == 1
                    ? '${judge.sugarInDrinks} cucharilla'
                    : '${judge.sugarInDrinks} cucharillas'),
            _infoText('Condimentos:', seasoningsString),
            _infoText('Le disgusta:', judge.dislikes),
            _infoText('Comentarios:', judge.comment),
            const SizedBox(height: 20),
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
