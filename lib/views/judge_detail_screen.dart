import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/judge.dart';
import '../view_models/judge_viewmodel.dart';

class JudgeDetailScreen extends StatelessWidget {
  final Judge judge;

  const JudgeDetailScreen({Key? key, required this.judge}) : super(key: key);

  Widget informationRow(String title, String data) {
    return ListTile(
      title: Text(title,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
      subtitle: Text(data, style: TextStyle(fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    String certificationStatus =
        judge.applicationState == "approved" ? "Certificado" : "No Certificado";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blueGrey),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blueGrey.shade200,
                    child: Icon(Icons.person, size: 60, color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    judge.fullName,
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    certificationStatus,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: judge.applicationState == "approved"
                          ? const Color.fromARGB(255, 183, 255, 185)
                          : const Color.fromARGB(255, 253, 149, 142),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.blueGrey.shade200),
                  ...[
                    informationRow("Correo Electrónico", judge.email),
                    informationRow("Comentarios", judge.comment),
                    if (judge.smokes)
                      informationRow("Fumador", judge.smokes ? 'Sí' : 'No'),
                    if (judge.allergies.isNotEmpty)
                      informationRow("Alergias", judge.allergies.join(', ')),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: ElevatedButton(
              onPressed: () {
                final viewModel =
                    Provider.of<JudgeViewModel>(context, listen: false);
                viewModel.approveJudge(judge);
              },
              child: const Text('Aprobar Certificación'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey.shade200,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
