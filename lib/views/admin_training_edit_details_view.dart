import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/view_models/admin_training_edit_viewmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:catas_univalle/widgets/register/custom_textfield.dart';

class AdminTrainingEditDetailsView extends StatefulWidget {
  final Training training;
  final String eventId;

  AdminTrainingEditDetailsView(
      {Key? key, required this.training, required this.eventId})
      : super(key: key);

  @override
  _AdminTrainingEditDetailsViewState createState() =>
      _AdminTrainingEditDetailsViewState();
}

class _AdminTrainingEditDetailsViewState
    extends State<AdminTrainingEditDetailsView> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _locationUrlController;
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  File? _selectedPdf;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.training.name);
    _descriptionController =
        TextEditingController(text: widget.training.description);
    _locationController = TextEditingController(text: widget.training.location);
    _locationUrlController =
        TextEditingController(text: widget.training.locationUrl);
    _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.training.date);
    _startTime = TimeOfDay(
        hour: int.parse(widget.training.startTime.split(':')[0]),
        minute: int.parse(widget.training.startTime.split(':')[1]));
    _endTime = TimeOfDay(
        hour: int.parse(widget.training.endTime.split(':')[0]),
        minute: int.parse(widget.training.endTime.split(':')[1]));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _locationUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context, initialTime: isStartTime ? _startTime : _endTime);
    if (picked != null && picked != (isStartTime ? _startTime : _endTime)) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _uploadPdf() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      _selectedPdf = File(result.files.single.path!);
      await Provider.of<AdminTrainingEditViewModel>(context, listen: false)
          .uploadPDF(_selectedPdf!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 232, 137, 158),
        iconTheme: IconThemeData(color: Colors.white),
        title:
            Text('Editar Capacitación', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              final viewModel = Provider.of<AdminTrainingEditViewModel>(context,
                  listen: false);
              if (_selectedPdf != null) {
                await viewModel.uploadPDF(
                    _selectedPdf!);
              }
              widget.training.name = _nameController.text;
              widget.training.description = _descriptionController.text;
              widget.training.location = _locationController.text;
              widget.training.locationUrl = _locationUrlController.text;
              widget.training.date =
                  DateFormat('yyyy-MM-dd').format(_selectedDate);
              widget.training.startTime = _startTime.format(context);
              widget.training.endTime = _endTime.format(context);
              widget.training.pdfUrl = viewModel
                  .pdfUrl;
              await viewModel.updateTraining(widget.eventId, widget.training);
              Navigator.pop(context, widget.training);
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          CustomTextFormField(
            labelText: 'Nombre de la Capacitación',
            controller: _nameController,
          ),
          SizedBox(height: 20),
          CustomTextFormField(
            labelText: 'Descripción',
            controller: _descriptionController,
            maxLines: 3,
          ),
          SizedBox(height: 20),
          CustomTextFormField(
            labelText: 'Ubicación',
            controller: _locationController,
          ),
          SizedBox(height: 20),
          CustomTextFormField(
            labelText: 'URL de Ubicación',
            controller: _locationUrlController,
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text(
                'Fecha de la Capacitación: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
            trailing: Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text('Hora de inicio: ${_startTime.format(context)}'),
            trailing: Icon(Icons.timer),
            onTap: () => _selectTime(context, true),
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text('Hora de fin: ${_endTime.format(context)}'),
            trailing: Icon(Icons.timer),
            onTap: () => _selectTime(context, false),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _uploadPdf,
            child: Text('Editar PDF'),
          ),
        ],
      ),
    );
  }
}
