import 'dart:io';
import 'package:catas_univalle/widgets/trainings/custom_elevated_button.dart';
import 'package:catas_univalle/widgets/trainings/file_picker_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/view_models/training_viewmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:catas_univalle/widgets/register/custom_textfield.dart';

class TrainingForm extends StatefulWidget {
  final String eventId;

  const TrainingForm({Key? key, required this.eventId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrainingFormState();
}

class _TrainingFormState extends State<TrainingForm> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _locationUrlController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  File? _selectedImage;
  File? _selectedPdf;
  String? _selectedPdfUrl;

  @override
  void initState() {
    super.initState();
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
            CustomTextFormField(
              labelText: 'Nombre de la capacitación',
              controller: _nameController,
            ),
            CustomTextFormField(
              labelText: 'Descripción',
              controller: _descriptionController,
              maxLines: 3,
            ),
            CustomElevatedButton(
              text: 'Seleccionar Imagen',
              onPressed: () => _pickFile(true),
            ),
            if (_selectedImage != null) Image.file(_selectedImage!),
            CustomTextFormField(
              labelText: 'Ubicación',
              controller: _locationController,
            ),
            CustomTextFormField(
              labelText: 'URL de ubicación',
              controller: _locationUrlController,
            ),
            FilePickerButton(
              onFilePicked: (url) {
                setState(() {
                  _selectedPdfUrl =
                      url;
                });
              },
            ),
            if (_selectedPdf != null) Icon(Icons.picture_as_pdf, size: 48),
            Center(
              child: ListTile(
                title: Text("Seleccionar Fecha", textAlign: TextAlign.center),
                subtitle: Text(_selectedDate?.toString() ?? 'No seleccionada',
                    textAlign: TextAlign.center),
                onTap: _selectDate,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text("Hora de Inicio"),
                    subtitle:
                        Text(_startTime?.format(context) ?? 'No seleccionada'),
                    onTap: () => _selectTime(true),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text("Hora de Fin"),
                    subtitle:
                        Text(_endTime?.format(context) ?? 'No seleccionada'),
                    onTap: () => _selectTime(false),
                  ),
                ),
              ],
            ),
            CustomElevatedButton(
              text: 'Guardar Capacitación',
              onPressed: () {
                if (_selectedPdfUrl == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Por favor, selecciona un archivo PDF antes de guardar."),
                    backgroundColor: Colors.red,
                  ));
                  return;
                }
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
                  pdfUrl:
                      _selectedPdfUrl!,
                );
                Provider.of<TrainingViewModel>(context, listen: false)
                    .addTraining(widget.eventId, newTraining);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
