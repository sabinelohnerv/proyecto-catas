import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/view_models/judge_training_events_viewmodel.dart';
import 'package:catas_univalle/widgets/trainings/training_event_card.dart';

class JudgeTrainingEventsView extends StatelessWidget {
  final String judgeId;
  const JudgeTrainingEventsView({super.key, required this.judgeId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JudgeTrainingEventsViewModel(judgeId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Capacitaciones Por Evento',
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
        body: Consumer<JudgeTrainingEventsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.events.isEmpty) {
              return const Center(child: Text('No has aceptado eventos aún.'));
            }
            return ListView.builder(
              itemCount: viewModel.events.length,
              itemBuilder: (context, index) {
                Event event = viewModel.events[index];
                int numberOfTrainings = viewModel.trainingCounts[event.id] ?? 0;
                return TrainingEventCard(
                  event: event,
                  numberOfTrainings: numberOfTrainings,
                  onTap: () => viewModel.goToTrainingsListView(context, event),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
