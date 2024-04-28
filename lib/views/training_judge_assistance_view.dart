import 'package:catas_univalle/view_models/training_judge_assistance_viewmodel.dart';
import 'package:catas_univalle/widgets/training_assistances/training_assistance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class TrainingJudgeAssistanceView extends StatelessWidget {
  final String eventId;
  final String trainingId;

  const TrainingJudgeAssistanceView(
      {super.key, required this.eventId, required this.trainingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registrar Asistencia',
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
      body: ChangeNotifierProvider<TrainingJudgeAssistanceViewModel>(
        create: (context) =>
            TrainingJudgeAssistanceViewModel(eventId, trainingId),
        child: Consumer<TrainingJudgeAssistanceViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoadingEvent || viewModel.isLoadingTraining) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.combinedJudges.isEmpty) {
              return const Center(
                  child: Text('No has registrado anfitriones aún.'));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.combinedJudges.length,
                    itemBuilder: (context, index) {
                      final judge = viewModel.combinedJudges[index];
                      return TrainingAssistanceCard(
                          judge: judge,
                          number: index + 1,
                          onStateToggle: (changedJudge) {
                            viewModel.toggleJudgeAssistance(changedJudge.id);
                          });
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      viewModel.saveJudgesAssistance();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(42.5),
                    ),
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
