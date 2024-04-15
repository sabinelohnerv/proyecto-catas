import 'package:flutter/material.dart';
import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/views/judge_detail_view.dart';

class JudgeCard extends StatelessWidget {
  final Judge judge;

  const JudgeCard({super.key, required this.judge});

  @override
  Widget build(BuildContext context) {
    String statusLabel;
    Color statusColor;
    Color reliabilityColor;

    switch (judge.applicationState) {
      case "aprobado":
        statusLabel = "Aprobado";
        statusColor = Colors.green;
        break;
      case "rechazado":
        statusLabel = "Rechazado";
        statusColor = Colors.red;
        break;
      default:
        statusLabel = "Pendiente";
        statusColor = Colors.amber;
    }

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
        elevation: 2.0,
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Container(
                height: 515,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  judge.profileImgUrl.isNotEmpty
                      ? CircleAvatar(
                          radius: 30.0,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          backgroundImage: NetworkImage(judge.profileImgUrl),
                        )
                      : CircleAvatar(
                          radius: 30.0,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: const Icon(Icons.person,
                              size: 50, color: Colors.white),
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
                    statusLabel.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
