import 'package:flutter/material.dart';
import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/views/judge_detail_view.dart';

class JudgeCard extends StatelessWidget {
  final Judge judge;

  const JudgeCard({Key? key, required this.judge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JudgeDetailScreen(judge: judge),
          ),
        );
      },
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        elevation: 5.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            judge.profileImgUrl.isNotEmpty
                ? CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    backgroundImage: NetworkImage(judge.profileImgUrl),
                  )
                : CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
            const SizedBox(height: 10),
            Text(
              judge.fullName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              judge.applicationState == "approved"
                  ? "Certificado"
                  : "No Certificado",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: judge.applicationState == "approved"
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
