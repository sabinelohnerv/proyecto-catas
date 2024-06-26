import 'package:catas_univalle/widgets/judge/judge_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/judge.dart';
import '../view_models/judge_viewmodel.dart';
import '../widgets/judge/judge_information_group.dart';
import '../widgets/judge/judge_information_item.dart';

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
    Color statusColor;

    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    const fixedHeaderHeight = 275.0;

    switch (widget.judge.applicationState) {
      case "aprobado":
        certificationStatus = "Aprobado";
        statusColor = const Color.fromARGB(255, 97, 160, 117);
        break;
      case "rechazado":
        certificationStatus = "Rechazado";
        statusColor = const Color.fromARGB(255, 197, 91, 88);

        break;
      default:
        certificationStatus = "Pendiente";
        statusColor = const Color.fromARGB(255, 134,196,242);
    }

    if (widget.judge.reliability >= 90) {
      reliabilityColor = const Color.fromARGB(255, 97, 160, 117);
    } else if (widget.judge.reliability < 90 &&
        widget.judge.reliability >= 80) {
      reliabilityColor = const Color.fromARGB(255, 175, 225, 175);
    } else if (widget.judge.reliability < 80 &&
        widget.judge.reliability >= 70) {
      reliabilityColor = const Color.fromARGB(255, 251, 238, 132);
    } else if (widget.judge.reliability < 70 &&
        widget.judge.reliability >= 60) {
      reliabilityColor = const Color.fromARGB(255, 244, 161, 95);
    } else if (widget.judge.reliability < 60 &&
        widget.judge.reliability >= 50) {
      reliabilityColor = const Color.fromARGB(255, 242, 132, 78);
    } else {
      reliabilityColor = const Color.fromARGB(255, 197, 91, 88);
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
      body: Stack(
        children: [
          Positioned(
            top: statusBarHeight + appBarHeight,
            left: 0,
            right: 0,
            height: fixedHeaderHeight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: JudgeHeaderCard(
                fullName: widget.judge.fullName,
                email: widget.judge.email,
                statusLabel: certificationStatus,
                statusColor: statusColor,
                reliabilityPercentage: widget.judge.reliability.toString(),
                reliabilityColor: reliabilityColor,
                profileImgUrl: widget.judge.profileImgUrl,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: statusBarHeight + appBarHeight + fixedHeaderHeight),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InformationGroup(
                      title: 'INFORMACION BASICA',
                      items: [
                        InformationItem(
                          label: 'Nacimiento',
                          value: widget.judge.birthDate,
                          leadingIcon: Icons.calendar_today,
                        ),
                        InformationItem(
                          label: 'Género',
                          value: widget.judge.gender == 'F'
                              ? 'Femenino'
                              : 'Masculino',
                          leadingIcon: Icons.person_sharp,
                        ),
                        InformationItem(
                          label: 'Rol',
                          value: widget.judge.roleAsJudge,
                          leadingIcon: Icons.badge,
                        ),
                        InformationItem(
                          label: 'Disponibilidad',
                          value: widget.judge.hasTime ? "Sí" : "No",
                          leadingIcon: Icons.timer_rounded,
                        ),
                      ],
                    ),
                    InformationGroup(
                      title: 'FUMADOR',
                      items: [
                        InformationItem(
                          label: 'Fumador:',
                          value: widget.judge.smokes ? "Sí" : "No",
                          leadingIcon: Icons.smoking_rooms,
                        ),
                        InformationItem(
                          label: 'Cigarrillos al día:',
                          value: widget.judge.cigarettesPerDay.toString(),
                          leadingIcon: Icons.smoke_free,
                        ),
                      ],
                    ),
                    InformationGroup(
                      title: 'CAFE',
                      items: [
                        InformationItem(
                          label: 'Café:',
                          value: widget.judge.coffee,
                          leadingIcon: Icons.coffee_maker,
                        ),
                        InformationItem(
                          label: 'Tazas al día:',
                          value: widget.judge.coffeeCupsPerDay.toString(),
                          leadingIcon: Icons.coffee,
                        ),
                      ],
                    ),
                    InformationGroup(
                      title: 'CONDIMENTACION',
                      items: [
                        InformationItem(
                          label: 'Picante o Llajua:',
                          value: widget.judge.llajua,
                          leadingIcon: Icons.local_fire_department,
                        ),
                        InformationItem(
                          label: 'Azúcar en bebidas:',
                          value: widget.judge.sugarInDrinks == 1
                              ? '${widget.judge.sugarInDrinks} cucharilla'
                              : '${widget.judge.sugarInDrinks} cucharillas',
                          leadingIcon: Icons.emoji_food_beverage_rounded,
                        ),
                        InformationItem(
                          label: 'Condimentos:',
                          value: widget.judge.seasonings.join('\n'),
                          leadingIcon: Icons.flaky,
                        ),
                      ],
                    ),
                    InformationGroup(
                      title: 'SALUD',
                      items: [
                        InformationItem(
                          label: 'Síntomas:',
                          value: widget.judge.symptoms.join('\n'),
                          leadingIcon: Icons.health_and_safety,
                        ),
                        InformationItem(
                          label: 'Alergias:',
                          value: widget.judge.allergies.join('\n'),
                          leadingIcon: Icons.warning_amber_rounded,
                        ),
                        InformationItem(
                          label: 'Le disgusta:',
                          value: widget.judge.dislikes,
                          leadingIcon: Icons.thumb_down_off_alt,
                        ),
                      ],
                    ),
                    InformationGroup(
                      title: 'COMENTARIOS',
                      items: [
                        InformationItem(
                          label: 'Comentario:',
                          value: widget.judge.comment,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.judge.applicationState != 'aprobado')
              ElevatedButton.icon(
                onPressed: _approveJudge,
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text('APROBAR',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 97, 160, 117),
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          widget.judge.applicationState == 'PENDING' ? 30 : 60),
                ),
              ),
            if (widget.judge.applicationState != 'rechazado')
              ElevatedButton.icon(
                onPressed: _rejectJudge,
                icon: const Icon(Icons.close, color: Colors.white),
                label: const Text('RECHAZAR',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 197, 91, 88),
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          widget.judge.applicationState == 'PENDING' ? 30 : 60),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
