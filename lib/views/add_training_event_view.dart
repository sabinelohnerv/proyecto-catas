import 'package:catas_univalle/view_models/training_event_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/models/training_event.dart';
import '/models/event.dart'; // Asegúrate de tener este modelo
import '/view_models/cata_events_viewmodel.dart'; // ViewModel para cargar eventos de cata

class AddTrainingEventView extends StatefulWidget {
  const AddTrainingEventView({Key? key}) : super(key: key);

  @override
  _AddTrainingEventViewState createState() => _AddTrainingEventViewState();
}

class _AddTrainingEventViewState extends State<AddTrainingEventView> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  String location = '';
  String? selectedCataEventId; // ID del evento de cata seleccionado

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _timeFormat = DateFormat('HH:mm');

  @override
  void initState() {
    super.initState();
    // Asegurarse de que los eventos de cata se cargan
    Provider.of<CataEventsViewModel>(context, listen: false).loadCataEvents();
  }

  @override
  Widget build(BuildContext context) {
    final cataEventsViewModel = Provider.of<CataEventsViewModel>(context);
    final trainingEventViewModel = Provider.of<TrainingEventListViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Evento de Capacitación'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (value) => value == null || value.isEmpty ? 'Por favor introduce un título' : null,
                  onSaved: (value) => title = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) => value == null || value.isEmpty ? 'Por favor introduce una descripción' : null,
                  onSaved: (value) => description = value ?? '',
                ),
                // Otros campos como fecha, hora, ubicación aquí...
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Evento de Cata Asociado'),
                  value: selectedCataEventId,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCataEventId = newValue;
                    });
                  },
                  items: cataEventsViewModel.cataEvents.map((Event event) {
                    return DropdownMenuItem<String>(
                      value: event.id,
                      child: Text(event.name),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Selecciona un evento de cata' : null,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Construir objeto TrainingEvent y llamar a addTrainingEvent
                      await trainingEventViewModel.addTrainingEvent(
                        TrainingEvent(
                          id: '', // ID será generado por Firestore
                          title: title,
                          description: description,
                          objectives: [], // Considerar implementar la recogida de objetivos
                          startDate: selectedStartDate != null ? _dateFormat.format(selectedStartDate!) : '',
                          endDate: selectedEndDate != null ? _dateFormat.format(selectedEndDate!) : '',
                          startTime: selectedStartTime != null ? _timeFormat.format(DateTime(0, 0, 0, selectedStartTime!.hour, selectedStartTime!.minute)) : '',
                          endTime: selectedEndTime != null ? _timeFormat.format(DateTime(0, 0, 0, selectedEndTime!.hour, selectedEndTime!.minute)) : '',
                          location: location,
                          linkedCataEventId: selectedCataEventId!,
                        ),
                      );
                      Navigator.of(context).pop(); // Regresar a pantalla anterior
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
