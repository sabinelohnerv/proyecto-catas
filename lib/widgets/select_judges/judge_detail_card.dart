import 'package:flutter/material.dart';
import 'package:catas_univalle/models/judge.dart';

class JudgeDetailCard extends StatelessWidget {
  final Judge judge;

  const JudgeDetailCard({Key? key, required this.judge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String seasoningsString = judge.seasonings.join(', ');
    String smokesString = judge.smokes ? 'Sí' : 'No';

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
            Text(
              judge.fullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
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
            _infoText('Género:', judge.gender),
            _infoText('Le disgusta:', judge.dislikes),
            _infoText('Fuma:', smokesString),
            if (judge.smokes)
              _infoText('Cigarillos por día:', '${judge.cigarettesPerDay}'),
            _infoText('Café:', judge.coffee),
            if (judge.coffee.toLowerCase() != 'nunca')
              _infoText('Tazas de café al día:', '${judge.coffeeCupsPerDay}'),
            _infoText('Picante o Llajua:', judge.llajua),
            _infoText('Condimentos:', seasoningsString),
            _infoText(
                'Azúcar en Bebidas:',
                judge.sugarInDrinks == 1
                    ? '${judge.sugarInDrinks} cucharilla'
                    : '${judge.sugarInDrinks} cucharillas'),
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
