import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/judge.dart';
import '../view_models/judge_viewmodel.dart';

class JudgeDetailScreen extends StatefulWidget {
  final Judge judge;

  const JudgeDetailScreen({Key? key, required this.judge}) : super(key: key);

  @override
  _JudgeDetailScreenState createState() => _JudgeDetailScreenState();
}

class _JudgeDetailScreenState extends State<JudgeDetailScreen> {
  Widget informationRow(String title, String data) {
    return ListTile(
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary)),
      subtitle: Text(data, style: const TextStyle(fontSize: 16)),
    );
  }

  void _approveJudge() {
    final viewModel = Provider.of<JudgeViewModel>(context, listen: false);
    viewModel.approveJudge(widget.judge, () {
      setState(() {
        widget.judge.applicationState = "approved";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String certificationStatus = widget.judge.applicationState == "approved"
        ? "Certificado"
        : "No Certificado";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 30.0,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(widget.judge.fullName,
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface)),
                  SizedBox(height: 10),
                  Text(certificationStatus,
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: widget.judge.applicationState == "approved"
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error)),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  informationRow("Dislikes", widget.judge.dislikes),
                  informationRow("Síntomas", widget.judge.symptoms.join(', ')),
                  informationRow("Alergias", widget.judge.allergies.join(', ')),
                  informationRow("Comentario", widget.judge.comment),
                  ExpansionTile(
                    title: Text("Ver más información",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary)),
                    children: <Widget>[
                      informationRow("Email", widget.judge.email),
                      informationRow("Género", widget.judge.gender),
                      informationRow("Cumpleaños", widget.judge.birthDate),
                      informationRow(
                          "Fumador", widget.judge.smokes ? "Sí" : "No"),
                      informationRow("Café", widget.judge.coffee),
                      informationRow("Llajua", widget.judge.llajua),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ElevatedButton(
                        onPressed: _approveJudge,
                        child: const Text('Aprobar Certificación',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                        ),
                      ),
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
