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
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
      subtitle: Text(data, style: TextStyle(fontSize: 16)),
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
    String certificationStatus = widget.judge.applicationState == "approved" ? "Certificado" : "No Certificado";

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
                  Text(widget.judge.fullName, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  Text(
                    certificationStatus,
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: widget.judge.applicationState == "approved" ? Color.fromARGB(255, 0, 0, 0) : Color.fromARGB(255, 0, 0, 0)),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.blueGrey.shade200),
                  ...[
                    informationRow("Correo Electrónico", widget.judge.email),
                    informationRow("Comentarios", widget.judge.comment),
                    if (widget.judge.smokes) informationRow("Fumador", widget.judge.smokes ? 'Sí' : 'No'),
                    if (widget.judge.allergies.isNotEmpty) informationRow("Alergias", widget.judge.allergies.join(', ')),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: ElevatedButton(
              onPressed: _approveJudge, 
              child: const Text('Aprobar Certificación'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey.shade200,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
