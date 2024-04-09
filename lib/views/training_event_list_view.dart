import 'package:catas_univalle/view_models/training_event_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/views/add_training_event_view.dart';

class TrainingEventListView extends StatelessWidget {
  const TrainingEventListView({Key? key, required this.isAdmin}) : super(key: key);
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capacitaciones'),
      ),
      body: Consumer<TrainingEventListViewModel>(
        builder: (context, viewModel, child) {
          return ListView.builder(
            itemCount: viewModel.trainingEvents.length,
            itemBuilder: (context, index) {
              final event = viewModel.trainingEvents[index];
              return ListTile(
                title: Text(event.title),
                subtitle: Text(event.description),
                // Agrega otras propiedades si es necesario
              );
            },
          );
        },
      ),
      floatingActionButton: isAdmin ? FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddTrainingEventView()),
        ),
        tooltip: 'Añadir Evento de Capacitación',
        child: const Icon(Icons.add),
      ) : null,
    );
  }
}
