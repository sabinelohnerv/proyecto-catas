import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/judge.dart';
import '../view_models/judge_viewmodel.dart';

class JudgeDetailScreen extends StatefulWidget {
  final Judge judge;

  const JudgeDetailScreen({super.key, required this.judge});

  @override
  State<StatefulWidget> createState() {
    return _JudgeDetailScreenState();
  }
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
    Color reliabilityColor;

    switch (widget.judge.applicationState) {
      case "aprobado":
        certificationStatus = "Aprobado";
        break;
      case "rechazado":
        certificationStatus = "Rechazado";
        break;
      default:
        certificationStatus = "Pendiente";
    }

    if (widget.judge.reliability >= 90) {
      reliabilityColor = Colors.green;
    } else if (widget.judge.reliability < 90 &&
        widget.judge.reliability >= 80) {
      reliabilityColor = Colors.lightGreen;
    } else if (widget.judge.reliability < 80 &&
        widget.judge.reliability >= 70) {
      reliabilityColor = Colors.yellow.shade400;
    } else if (widget.judge.reliability < 70 &&
        widget.judge.reliability >= 60) {
      reliabilityColor = Colors.amber;
    } else if (widget.judge.reliability < 60 &&
        widget.judge.reliability >= 50) {
      reliabilityColor = Colors.orange;
    } else {
      reliabilityColor = Colors.red;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 90),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
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
                            child: const Icon(Icons.person,
                                size: 120, color: Colors.white),
                          ),
                    const SizedBox(height: 20),
                    Text(widget.judge.fullName,
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 2),
                    Text(widget.judge.email,
                        style: TextStyle(
                            fontSize: 16.0, color: Colors.grey.shade700)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          certificationStatus,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: certificationStatus == "Aprobado"
                                  ? Colors.green
                                  : certificationStatus == "Rechazado"
                                      ? Colors.red
                                      : Colors.amber),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: reliabilityColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${widget.judge.reliability.toString()}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    informationRow(
                        "Fecha de Nacimiento", widget.judge.birthDate),
                    informationRow("Género",
                        widget.judge.gender == 'F' ? 'Femenino' : 'Masculino'),
                    informationRow(
                        "Rol en la institución", widget.judge.roleAsJudge),
                    informationRow(
                        "Tiempo semanal disponible", widget.judge.hasTime ? "Sí" : "No"),
                    ExpansionTile(
                      title: Text("Más información",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary)),
                      children: <Widget>[
                        informationRow(
                            "Fumador", widget.judge.smokes ? "Sí" : "No"),
                        informationRow("Cigarrillos al día",
                            widget.judge.cigarettesPerDay.toString()),
                        informationRow("Café", widget.judge.coffee),
                        informationRow("Tazas de café al día",
                            widget.judge.coffeeCupsPerDay.toString()),
                        informationRow("Picante o Llajua", widget.judge.llajua),
                        informationRow(
                            "Azúcar en bebidas",
                            widget.judge.sugarInDrinks == 1
                                ? '${widget.judge.sugarInDrinks.toString()} cucharilla'
                                : '${widget.judge.sugarInDrinks.toString()} cucharillas'),
                        informationRow(
                            "Condimentos", widget.judge.seasonings.join(', ')),
                        informationRow(
                            "Síntomas", widget.judge.symptoms.join(', ')),
                        informationRow(
                            "Alergias", widget.judge.allergies.join(', ')),
                        informationRow("Le disgusta", widget.judge.dislikes),
                        informationRow("Comentario", widget.judge.comment),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _approveJudge,
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text('Aprobar',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _rejectJudge,
              icon: const Icon(Icons.close, color: Colors.white),
              label: const Text('Rechazar',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
