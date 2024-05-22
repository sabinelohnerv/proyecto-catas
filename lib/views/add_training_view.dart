import 'package:catas_univalle/models/event_judge.dart';
import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/view_models/training_viewmodel.dart';
import 'package:catas_univalle/widgets/register/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import '/functions/util.dart';

class AddTrainingView extends StatefulWidget {
  final String eventId;

  const AddTrainingView({super.key, required this.eventId});

  @override
  State<StatefulWidget> createState() => _AddTrainingViewState();
}

class _AddTrainingViewState extends State<AddTrainingView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _locationUrlController = TextEditingController();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedPdfUrl;
  String? _selectedPdfName;

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
        _dateController.text =
            formatDateToWrittenDate(picked.toIso8601String());
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
          _startTimeController.text = picked.format(context);
        } else {
          _endTime = picked;
          _endTimeController.text = picked.format(context);
        }
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedPdfUrl = result.files.single.path;
        _selectedPdfName = result.files.single.name;
      });
    }
  }

  void _removeSelectedPdf() {
    setState(() {
      _selectedPdfUrl = null;
      _selectedPdfName = null;
    });
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
                bottomRight: Radius.circular(40),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text(
              "Agregar Capacitación",
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            ),
            centerTitle: true,
          ),
        ],
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
          child: Form(
            key: _formKey,
            child: Container(
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    child: Text(
                      'Datos Generales de la Capacitación',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  CustomTextFormField(
                    labelText: 'Nombre de la capacitación',
                    prefixIcon: const Icon(Icons.assignment),
                    controller: _nameController,
                  ),
                  CustomTextFormField(
                    labelText: 'Descripción',
                    prefixIcon: const Icon(Icons.description),
                    controller: _descriptionController,
                    maxLines: 3,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 6),
                    child: Text(
                      'Ejecución de la Capacitación',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  CustomTextFormField(
                    labelText: 'Ubicación',
                    prefixIcon: const Icon(Icons.place),
                    controller: _locationController,
                  ),
                  CustomTextFormField(
                    labelText: 'URL de ubicación',
                    prefixIcon: const Icon(Icons.link),
                    controller: _locationUrlController,
                  ),
                  CustomTextFormField(
                    labelText: 'Fecha',
                    prefixIcon: const Icon(Icons.calendar_today),
                    controller: _dateController,
                    readOnly: true,
                    onTap: _selectDate,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          labelText: ' Inicio',
                          prefixIcon: const Icon(Icons.access_time),
                          controller: _startTimeController,
                          readOnly: true,
                          onTap: () => _selectTime(true),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextFormField(
                          labelText: 'Fin',
                          prefixIcon: const Icon(Icons.access_time),
                          controller: _endTimeController,
                          readOnly: true,
                          onTap: () => _selectTime(false),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Documentación Complementaria',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        dashPattern: const [6, 3],
                        color: Colors.grey,
                        strokeWidth: 2,
                        child: InkWell(
                          onTap: _pickFile,
                          child: Container(
                            color: Colors.grey.shade100,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
                              child: Row(
                                children: [
                                  Icon(Icons.picture_as_pdf,
                                      color: _selectedPdfUrl != null
                                          ? Colors.green
                                          : Colors.grey.shade600,
                                      size: 34),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _selectedPdfUrl == null
                                          ? 'No has seleccionado un PDF'
                                          : _selectedPdfName ?? '',
                                      style: const TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (_selectedPdfUrl != null)
                                    IconButton(
                                      icon: Icon(Icons.close,
                                          color: Colors.grey.shade900),
                                      onPressed: _removeSelectedPdf,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Seleccionar PDF"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.onInverseSurface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      child: Text(
                        'Solo archivos .pdf permitidos',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade800),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 25, 15, 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedPdfUrl == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor, selecciona un PDF.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        List<EventJudge> judges = [];
                        Training newTraining = Training(
                          id: '',
                          name: _nameController.text,
                          description: _descriptionController.text,
                          startTime: _startTime?.format(context) ?? '',
                          endTime: _endTime?.format(context) ?? '',
                          date: _selectedDate?.toIso8601String() ?? '',
                          location: _locationController.text,
                          locationUrl: _locationUrlController.text,
                          pdfUrl: _selectedPdfUrl,
                          judges: judges,
                        );

                        Provider.of<TrainingViewModel>(context, listen: false)
                            .addTraining(widget.eventId, newTraining);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Guardar Capacitación',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
