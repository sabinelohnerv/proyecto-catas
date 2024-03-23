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
    viewModel.updateJudgeApplicationState(widget.judge, "aprobado", () {
      setState(() {
        widget.judge.applicationState = "aprobado";
      });
    });
  }

  void _rejectJudge() {
    final viewModel = Provider.of<JudgeViewModel>(context, listen: false);
    viewModel.updateJudgeApplicationState(widget.judge, "rechazado", () {
      setState(() {
        widget.judge.applicationState = "rechazado";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String certificationStatus;
    switch (widget.judge.applicationState) {
      case "aprobado":
        certificationStatus = "Aprobado";
        break;
      case "rechazado":
        certificationStatus = "Rechazado";
        break;
      default:
        certificationStatus = "pendiente";
    }

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
                  widget.judge.profileImgUrl.isNotEmpty
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              NetworkImage(widget.judge.profileImgUrl),
                        )
                      : CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          radius: 60,
                          child: Icon(Icons.person,
                              size: 120, color: Colors.white),
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
                          color: certificationStatus == "Aprobado"
                              ? Colors.green
                              : certificationStatus == "Rechazado"
                                  ? Colors.red
                                  : Colors.amber)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _approveJudge,
                        icon: Icon(Icons.check, color: Colors.white),
                        label: Text('Aprobar',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color.fromARGB(255, 232, 137, 158),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), 
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _rejectJudge,
                        icon: Icon(Icons.close, color: Colors.white),
                        label: Text('Rechazar',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 232, 137, 158),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
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
