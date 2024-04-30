import 'package:catas_univalle/view_models/training_judges_viewmodel.dart';
import 'package:catas_univalle/widgets/training_assistances/training_judge_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event_judge.dart';

class TrainingJudgesView extends StatelessWidget {
  final String eventId;
  final String trainingId;

  const TrainingJudgesView(
      {super.key, required this.eventId, required this.trainingId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TrainingJudgesViewModel(eventId, trainingId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Asistencia',
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
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () => TrainingJudgesViewModel(eventId, trainingId)
                    .goToTrainingJudgeAssistanceView(context)),
          ],
        ),
        body: Consumer<TrainingJudgesViewModel>(
          builder: (context, viewModel, child) {
            return StreamBuilder<List<EventJudge>>(
              stream: viewModel.trainingJudgesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("Aún no hay un registro de asistencia."));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    EventJudge judge = snapshot.data![index];
                    return TrainingJudgeCard(
                      judge: judge,
                      number: index + 1,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
