import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/view_models/judge_trainings_list_viewmodel.dart';
import 'package:catas_univalle/widgets/trainings/training_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainingsListView extends StatelessWidget {
  final Event event;
  const TrainingsListView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          event.name,
          style: const TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis,
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
      body: ChangeNotifierProvider<TrainingsListViewModel>(
        create: (context) => TrainingsListViewModel(event.id),
        child: Consumer<TrainingsListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.trainings.isEmpty) {
              return const Center(child: Text('Aún no hay capacitaciones programadas.'));
            }
            return ListView.builder(
              itemCount: viewModel.trainings.length,
              itemBuilder: (context, index) {
                final training = viewModel.trainings[index];
                return TrainingCard(
                  training: training,
                  onTap: () => viewModel.goToTrainingDetailsView(context, training), onDelete: () {  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
