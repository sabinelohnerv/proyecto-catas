import 'package:catas_univalle/views/admin_training_details_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/view_models/training_list_viewmodel.dart';
import 'package:catas_univalle/widgets/trainings/training_card.dart';

class TrainingListView extends StatefulWidget {
  final String eventId;
  final bool isAdmin;

  const TrainingListView({Key? key, required this.eventId, required this.isAdmin}) : super(key: key);

  @override
  _TrainingListViewState createState() => _TrainingListViewState();
}

class _TrainingListViewState extends State<TrainingListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<TrainingListViewModel>(context, listen: false).fetchTrainings(widget.eventId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capacitaciones', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (widget.isAdmin)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, '/addTraining', arguments: widget.eventId),
            )
        ],
      ),
      body: Consumer<TrainingListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.trainings.isEmpty) {
            return const Center(child: Text('No hay capacitaciones disponibles.'));
          }
          return ListView.builder(
            itemCount: viewModel.trainings.length,
            itemBuilder: (context, index) {
              Training training = viewModel.trainings[index];
              return TrainingCard(
                training: training,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminTrainingDetailsView(training: training),
                  ),
                ),
                onDelete: () {
                  // TODO: logica para confirmar y eliminar una capacitación
                },
              );
            },
          );
        },
      ),
    );
  }
}
