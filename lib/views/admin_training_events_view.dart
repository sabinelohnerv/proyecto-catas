import 'package:catas_univalle/services/training_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/widgets/trainings/training_event_card.dart';
import 'package:catas_univalle/view_models/admin_training_events_viewmodel.dart';

class AdminTrainingEventsView extends StatelessWidget {
  const AdminTrainingEventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AdminTrainingEventsViewModel>(
      create: (context) => AdminTrainingEventsViewModel(
        trainingService: Provider.of<TrainingService>(context, listen: false),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todas las Capacitaciones', style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Consumer<AdminTrainingEventsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.events.isEmpty) {
              return const Center(child: Text('No hay capacitaciones disponibles.'));
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
