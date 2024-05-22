import 'package:catas_univalle/views/all_training_assistances_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/view_models/training_list_viewmodel.dart';
import 'package:catas_univalle/widgets/trainings/training_card.dart';
import 'package:catas_univalle/views/admin_training_details_view.dart';

class TrainingListView extends StatefulWidget {
  final String eventId;
  final bool isAdmin;

  const TrainingListView(
      {super.key, required this.eventId, required this.isAdmin});

  @override
  _TrainingListViewState createState() => _TrainingListViewState();
}

class _TrainingListViewState extends State<TrainingListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<TrainingListViewModel>(context, listen: false)
            .subscribeToTrainings(widget.eventId);
      }
    });
  }

  @override
  void dispose() {
    Provider.of<TrainingListViewModel>(context, listen: false).dispose();
    super.dispose();
  }

  void _confirmDeletion(Training training) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar Capacitación"),
          content: const Text("¿Estás seguro de querer eliminar esta capacitación?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Provider.of<TrainingListViewModel>(context, listen: false).deleteTraining(widget.eventId, training.id);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Capacitaciones', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (widget.isAdmin)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 30,),
              onPressed: () => Navigator.pushNamed(context, '/addTraining',
                  arguments: widget.eventId),
            )
        ],
      ),
      body: Consumer<TrainingListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.trainings.isEmpty) {
            return const Center(
                child: Text('No hay capacitaciones disponibles.'));
          }
          return ListView.builder(
            itemCount: viewModel.trainings.length,
            itemBuilder: (context, index) {
              Training training = viewModel.trainings[index];
              return Dismissible(
                key: Key(training.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _confirmDeletion(training);
                },
                background: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: TrainingCard(
                  training: training,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminTrainingDetailsView(training: training, eventId: widget.eventId),
                      ),
                    );
                  }, onDelete: () {  },
                ),
              );
            },
          );
        },
      ),
      persistentFooterButtons: [
        Center(
            child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllTrainingsJudgeAttendanceView(
                  eventId: widget.eventId,
                ),
              ),
            );
          },
          label: const Text('ASISTENCIAS'),
          icon: const Icon(Icons.contacts),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
        ))
      ],
    );
  }
}
