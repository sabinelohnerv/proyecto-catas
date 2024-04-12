import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/view_models/training_event_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/models/training_event.dart';
import '/view_models/cata_events_viewmodel.dart';

class TrainingEventForm extends StatefulWidget {
  const TrainingEventForm({Key? key}) : super(key: key);

  @override
  _TrainingEventFormState createState() => _TrainingEventFormState();
}

class _TrainingEventFormState extends State<TrainingEventForm> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  String location = '';
  String? selectedCataEventId;

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _timeFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cataEventsViewModel = Provider.of<CataEventsViewModel>(context);
    final trainingEventViewModel = Provider.of<TrainingEventListViewModel>(context, listen: false);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Por favor introduce un título' : null,
                onSaved: (value) => title = value ?? '',
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) => value?.isEmpty ?? true ? 'Por favor introduce una descripción' : null,
                onSaved: (value) => description = value ?? '',
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Ubicación',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.place),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Por favor introduce una ubicación' : null,
                onSaved: (value) => location = value ?? '',
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Evento de Cata Asociado',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.event_available),
                ),
                value: selectedCataEventId,
                items: cataEventsViewModel.cataEvents.map((Event event) {
                  return DropdownMenuItem<String>(
                    value: event.id,
                    child: Text(event.name),
                  );
                }).toList(),
                onChanged: (newValue) => setState(() => selectedCataEventId = newValue),
                validator: (value) => value == null ? 'Selecciona un evento de cata' : null,
              ),
              SizedBox(height: 16),
              _DateAndTimePicker(
                label: 'Fecha de Inicio',
                selectedDate: selectedStartDate,
                selectedTime: selectedStartTime,
                onDateChanged: (date) => setState(() => selectedStartDate = date),
                onTimeChanged: (time) => setState(() => selectedStartTime = time),
              ),
              SizedBox(height: 16),
              _DateAndTimePicker(
                label: 'Fecha de Fin',
                selectedDate: selectedEndDate,
                selectedTime: selectedEndTime,
                onDateChanged: (date) => setState(() => selectedEndDate = date),
                onTimeChanged: (time) => setState(() => selectedEndTime = time),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: theme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    TrainingEvent newEvent = TrainingEvent(
                      id: '',
                      title: title,
                      description: description,
                      objectives: [], // Este campo puede requerir un enfoque especial
                      startDate: selectedStartDate != null ? _dateFormat.format(selectedStartDate!) : '',
                      endDate: selectedEndDate != null ? _dateFormat.format(selectedEndDate!) : '',
                      startTime: selectedStartTime != null ? _timeFormat.format(DateTime(0, 0, 0, selectedStartTime!.hour, selectedStartTime!.minute)) : '',
                      endTime: selectedEndTime != null ? _timeFormat.format(DateTime(0, 0, 0, selectedEndTime!.hour, selectedEndTime!.minute)) : '',
                      location: location,
                      linkedCataEventId: selectedCataEventId!,
                    );
                    await trainingEventViewModel.addTrainingEvent(newEvent);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Crear Capacitación', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateAndTimePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const _DateAndTimePicker({
    Key? key,
    required this.label,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateChanged,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateFormat timeFormat = DateFormat('HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () async {
                  final DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (date != null) onDateChanged(date);
                },
                child: Text(
                  selectedDate == null ? 'Seleccionar fecha' : dateFormat.format(selectedDate!),
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () async {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime ?? TimeOfDay.now(),
                  );
                  if (time != null) onTimeChanged(time);
                },
                child: Text(
                  selectedTime == null ? 'Seleccionar hora' : timeFormat.format(DateTime(0, 0, 0, selectedTime!.hour, selectedTime!.minute)),
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
