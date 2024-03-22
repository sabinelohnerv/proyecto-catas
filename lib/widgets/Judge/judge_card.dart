import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/views/judge_detail_view.dart';
import 'package:flutter/material.dart';

class JudgeCard extends StatelessWidget {
  final Judge judge;

  const JudgeCard({Key? key, required this.judge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String certificationStatus =
        judge.applicationState == "approved" ? "Certificado" : "No Certificado";
    Color statusColor = judge.applicationState == "approved"
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.error;

    String imageUrl = judge.profileImgUrl;

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
            CircleAvatar(
              radius: 30.0,
              backgroundImage:
                  imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: imageUrl.isEmpty
                  ? Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
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
              certificationStatus,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
