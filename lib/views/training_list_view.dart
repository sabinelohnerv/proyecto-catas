import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/view_models/training_list_viewmodel.dart';

class TrainingListView extends StatefulWidget {
  final String eventId;
  final bool isAdmin;

  const TrainingListView({
    Key? key,
    required this.eventId,
    required this.isAdmin,
  }) : super(key: key);

  @override
  _TrainingListViewState createState() => _TrainingListViewState();
}

class _TrainingListViewState extends State<TrainingListView> {
  @override
  void initState() {
    super.initState();
    if (widget.eventId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<TrainingListViewModel>(context, listen: false)
            .fetchTrainings(widget.eventId);
      });
    } else {
      print('Error: eventId is empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capacitaciones'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (widget.eventId.isNotEmpty) {
                Navigator.pushNamed(context, '/addTraining',
                    arguments: widget.eventId);
              } else {
                print(
                    'Error: Cannot navigate to add training as eventId is empty');
              }
            },
          )
        ],
      ),
      body: Consumer<TrainingListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (viewModel.trainings.isEmpty) {
            return Center(child: Text('No hay capacitaciones disponibles.'));
          }
          return ListView.builder(
            itemCount: viewModel.trainings.length,
            itemBuilder: (context, index) {
              Training training = viewModel.trainings[index];
              return ListTile(
                title: Text(training.name),
                subtitle: Text('Fecha: ${training.date}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirmar"),
                          content: Text("¿Deseas eliminar esta capacitación?"),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancelar',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: Text('Eliminar',
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error)),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop();
                                Provider.of<TrainingListViewModel>(context,
                                        listen: false)
                                    .deleteTraining(
                                        widget.eventId, training.id);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                onTap: () {
                //  TODO: Agregar función de editar capacitación
                  Navigator.pushNamed(context, '/editTraining',
                      arguments: training);
                },
              );
            },
          );
        },
      ),
    );
  }
}
