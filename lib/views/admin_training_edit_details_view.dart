import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/view_models/admin_training_edit_viewmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:catas_univalle/widgets/register/custom_textfield.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  String? _selectedPdfUrl;
  String? _selectedPdfName;
  File? _selectedPdfFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.training.name);
    _descriptionController =
        TextEditingController(text: widget.training.description);
    _locationController = TextEditingController(text: widget.training.location);
    _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.training.date);

    // Parse the start and end times with HH:mm format
    _startTime = _parseTime(widget.training.startTime);
    _endTime = _parseTime(widget.training.endTime);

    _selectedPdfUrl = widget.training.pdfUrl;
    _selectedPdfName = widget.training.pdfUrl?.split('/').last;
  }

  TimeOfDay _parseTime(String time) {
    final format = DateFormat.Hm(); // 24-hour format
    final dateTime = format.parse(time);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
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
    final viewModel =
        Provider.of<AdminTrainingEditViewModel>(context, listen: false);
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      File selectedFile = File(result.files.single.path!);
      String fileName = result.files.single.name;

      setState(() {
        _selectedPdfFile = selectedFile;
        _selectedPdfName = fileName;
      });

      viewModel.setUploading(true); // Show progress indicator

      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child('pdfs/$fileName');
        UploadTask uploadTask = ref.putFile(selectedFile);

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        setState(() {
          _selectedPdfUrl = downloadUrl;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        viewModel.setUploading(false); // Hide progress indicator
      }
    }
  }

  void _removeSelectedPdf() {
    setState(() {
      _selectedPdfUrl = null;
      _selectedPdfName = null;
      _selectedPdfFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AdminTrainingEditViewModel>(context);

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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    child: Text(
                      'Datos Generales de la Capacitación',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  CustomTextFormField(
                    labelText: 'Nombre de la Capacitación',
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
                    trailing: const Icon(Icons.edit, color: Colors.grey),
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
                    trailing: const Icon(Icons.edit, color: Colors.grey),
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
                    trailing: const Icon(Icons.edit, color: Colors.grey),
                    onTap: () => _selectTime(context, false),
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
                        onTap: _uploadPdf,
                        child: Container(
                          color: Colors.grey.shade100,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
                            child: Row(
                              children: [
                                Icon(Icons.picture_as_pdf,
                                    color: _selectedPdfUrl != null
                                        ? const Color.fromARGB(
                                            255, 97, 160, 117)
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
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (viewModel.isUploading)
                    Center(
                      child:
                          CircularProgressIndicator(), // Show progress indicator
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: ElevatedButton.icon(
                      onPressed: _uploadPdf,
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
                    padding: const EdgeInsets.fromLTRB(15, 25, 15, 5),
                    child: ElevatedButton(
                      onPressed: () async {
                        final viewModel =
                            Provider.of<AdminTrainingEditViewModel>(context,
                                listen: false);
                        if (_selectedPdfFile != null) {
                          await viewModel.uploadPDF(_selectedPdfFile!);
                          widget.training.pdfUrl = viewModel.pdfUrl;
                        }
                        widget.training.name = _nameController.text;
                        widget.training.description =
                            _descriptionController.text;
                        widget.training.location = _locationController.text;
                        widget.training.date =
                            DateFormat('yyyy-MM-dd').format(_selectedDate);
                        widget.training.startTime = _startTime.format(context);
                        widget.training.endTime = _endTime.format(context);
                        await viewModel.updateTraining(
                            widget.eventId, widget.training);
                        Navigator.pop(context, widget.training);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Guardar Cambios'),
                    ),
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
