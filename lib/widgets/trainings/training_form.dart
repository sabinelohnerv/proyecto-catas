import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/view_models/training_viewmodel.dart';
import 'package:file_picker/file_picker.dart';

class TrainingForm extends StatefulWidget {
  final String eventId;

  const TrainingForm({super.key, required this.eventId});

  @override
  State<StatefulWidget> createState() {
    return _TrainingFormState();
  }
}

class _TrainingFormState extends State<TrainingForm> {
  EventService eventService = EventService();
  List<Event> events = [];
  String? selectedEventId;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _locationUrlController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  File? _selectedImage;
  File? _selectedPdf;

  @override
  void initState() {
    super.initState();
    loadEvents();
    selectedEventId = widget.eventId;
  }

  void loadEvents() async {
    try {
      List<Event> loadedEvents = await eventService.fetchAllCataEvents();
      if (loadedEvents.isNotEmpty) {
        setState(() {
          events = loadedEvents;
          selectedEventId = selectedEventId ?? events[0].id;
        });
      }
    } catch (e) {
      print('Error loading events: $e');
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (isStartTime ? _startTime : _endTime) ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _pickFile(bool isImage) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: isImage ? FileType.image : FileType.custom,
      allowedExtensions: isImage ? null : ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        if (isImage) {
          _selectedImage = file;
        } else {
          _selectedPdf = file;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedEventId,
              onChanged: (String? newValue) {
                setState(() {
                  selectedEventId = newValue;
                });
              },
              items: events.map<DropdownMenuItem<String>>((Event event) {
                return DropdownMenuItem<String>(
                  value: event.id,
                  child: Text(event.name),
                );
              }).toList(),
              isExpanded: true,
            ),
            TextField(
              controller: _nameController,
              decoration:
                  InputDecoration(labelText: 'Nombre de la capacitación'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            ElevatedButton(
              onPressed: () => _pickFile(true),
              child: Text('Seleccionar Imagen'),
            ),
            if (_selectedImage != null)
              Image.file(_selectedImage!),  // Muestra la imagen seleccionada
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Ubicación'),
            ),
            TextField(
              controller: _locationUrlController,
              decoration: InputDecoration(labelText: 'URL de ubicación'),
            ),
            ElevatedButton(
              onPressed: () => _pickFile(false),
              child: Text('Seleccionar PDF'),
            ),
            if (_selectedPdf != null)
              Icon(Icons.picture_as_pdf, size: 48),  // Simplemente muestra un ícono representativo
            ListTile(
              title: Text("Seleccionar Fecha"),
              subtitle: Text(_selectedDate?.toString() ?? 'No seleccionada'),
              onTap: _selectDate,
            ),
            ListTile(
              title: Text("Hora de Inicio"),
              subtitle: Text(_startTime?.format(context) ?? 'No seleccionada'),
              onTap: () => _selectTime(true),
            ),
            ListTile(
              title: Text("Hora de Fin"),
              subtitle: Text(_endTime?.format(context) ?? 'No seleccionada'),
              onTap: () => _selectTime(false),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedEventId != null) {
                  Training newTraining = Training(
                    id: '',
                    name: _nameController.text,
                    description: _descriptionController.text,
                    imageUrl: _selectedImage?.path ?? '',
                    startTime: _startTime?.format(context) ?? '',
                    endTime: _endTime?.format(context) ?? '',
                    date: _selectedDate?.toIso8601String() ?? '',
                    location: _locationController.text,
                    locationUrl: _locationUrlController.text,
                    pdfUrl: _selectedPdf?.path ?? '',
                  );
                  Provider.of<TrainingViewModel>(context, listen: false)
                      .addTraining(selectedEventId!, newTraining);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Por favor, selecciona un evento antes de guardar.")));
                }
              },
              child: Text("Guardar Capacitación"),
            )
          ],
        ),
      ),
    );
  }
}
