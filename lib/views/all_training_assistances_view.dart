import 'package:catas_univalle/view_models/all_training_assistances_viewmodel.dart';
import 'package:catas_univalle/widgets/training_assistances/all_training_judge_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllTrainingsJudgeAttendanceView extends StatelessWidget {
  final String eventId;
  const AllTrainingsJudgeAttendanceView({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Porcentaje de Asistencias',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ChangeNotifierProvider<AllTrainingJudgeAssistanceViewModel>(
        create: (context) => AllTrainingJudgeAssistanceViewModel(eventId),
        child: Consumer<AllTrainingJudgeAssistanceViewModel>(
          builder: (context, model, child) {
            if (model.isLoadingEvent) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: model.judgeAttendances.length,
              itemBuilder: (context, index) {
                final attendance = model.judgeAttendances[index];
                double percentage = attendance.attendancePercentage;
                return AllTrainingJudgeCard(
                  judge: attendance.judgeName,
                  number: index+1,
                  percentage: percentage,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
