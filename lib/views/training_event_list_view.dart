import 'package:catas_univalle/view_models/training_event_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/views/add_training_event_view.dart';

class TrainingEventListView extends StatelessWidget {
  const TrainingEventListView({Key? key, required this.isAdmin}) : super(key: key);
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final Color seedColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: seedColor, 
        title: Text(
          'Capacitaciones',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Consumer<TrainingEventListViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.trainingEvents.isEmpty) {
            return Center(
              child: Text(
                'No hay eventos de capacitación disponibles.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            );
          }
          return ListView.separated(
            itemCount: viewModel.trainingEvents.length,
            separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
            itemBuilder: (context, index) {
              final event = viewModel.trainingEvents[index];
              final startDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(event.startDate));
              return ListTile(
                leading: Icon(Icons.event_note, color: seedColor),
                title: Text(event.title, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${event.description}\nFecha: $startDate\nUbicación: ${event.location}'),
                trailing: Icon(Icons.chevron_right, color: seedColor),
                onTap: () {},
              );
            },
          );
        },
      ),
      floatingActionButton: isAdmin ? FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddTrainingEventView())),
        backgroundColor: seedColor, 
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Agregar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ) : null,
    );
  }
}
