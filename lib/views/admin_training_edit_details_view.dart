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

  const AdminTrainingEditDetailsView(
      {super.key, required this.training, required this.eventId});

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
      setState(() {
        _selectedPdf = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40))),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text(
              "Editar Capacitación",
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            ),
            centerTitle: true,
          ),
        ],
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    labelText: 'Nombre de la Capacitación',
                    prefixIcon: const Icon(Icons.assignment),
                    controller: _nameController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Descripción',
                    controller: _descriptionController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Ubicación',
                    prefixIcon: const Icon(Icons.place),
                    controller: _locationController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'URL de Ubicación',
                    prefixIcon: const Icon(Icons.link),
                    controller: _locationUrlController,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _uploadPdf,
                          icon: const Icon(Icons.upload_file),
                          label: const Text("Editar PDF"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.onInverseSurface,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        if (_selectedPdf != null)
                          const Expanded(
                            child: ListTile(
                              leading: Icon(Icons.picture_as_pdf,
                                  color: Colors.green, size: 48),
                            ),
                          )
                        else
                          const Expanded(
                            child: ListTile(
                              leading: Icon(Icons.picture_as_pdf,
                                  color: Colors.grey, size: 48),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.onInverseSurface,
                      child: Icon(
                        Icons.calendar_month_sharp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: const Text(
                      'Fecha',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      DateFormat('dd MMMM, yyyy').format(_selectedDate),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: const Icon(Icons.edit, color: Colors.blueAccent),
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.onInverseSurface,
                      child: Icon(
                        Icons.access_time_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: const Text(
                      'Hora de inicio',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      _startTime.format(context),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: const Icon(Icons.edit, color: Colors.blueAccent),
                    onTap: () => _selectTime(context, true),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.onInverseSurface,
                      child: Icon(
                        Icons.access_time_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: const Text(
                      'Hora de fin',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      _endTime.format(context),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: const Icon(Icons.edit, color: Colors.blueAccent),
                    onTap: () => _selectTime(context, false),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final viewModel = Provider.of<AdminTrainingEditViewModel>(
                          context,
                          listen: false);
                      if (_selectedPdf != null) {
                        await viewModel.uploadPDF(_selectedPdf!);
                      }
                      widget.training.name = _nameController.text;
                      widget.training.description = _descriptionController.text;
                      widget.training.location = _locationController.text;
                      widget.training.locationUrl = _locationUrlController.text;
                      widget.training.date =
                          DateFormat('yyyy-MM-dd').format(_selectedDate);
                      widget.training.startTime = _startTime.format(context);
                      widget.training.endTime = _endTime.format(context);
                      widget.training.pdfUrl = viewModel.pdfUrl;
                      await viewModel.updateTraining(
                          widget.eventId, widget.training);
                      Navigator.pop(context, widget.training);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('EDITAR CAPACITACIÓN'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
