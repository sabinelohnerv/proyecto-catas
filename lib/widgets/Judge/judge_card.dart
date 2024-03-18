import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/views/judge_detail_screen.dart';
import 'package:flutter/material.dart';

class JudgeCard extends StatelessWidget {
  final Judge judge;

  const JudgeCard({Key? key, required this.judge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determina el estado de certificación del juez
    String certificationStatus = judge.applicationState == "approved" ? "Certificado" : "No Certificado";

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
        color: Colors.white,
        elevation: 5.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30.0,
              child: Icon(Icons.person, size: 50, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              judge.fullName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              certificationStatus,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: judge.applicationState == "approved" ? Color.fromARGB(255, 0, 0, 0) : Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
