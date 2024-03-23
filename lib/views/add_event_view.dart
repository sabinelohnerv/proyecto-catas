import 'dart:io';
import 'package:catas_univalle/widgets/register/custom_numberinput.dart';
import 'package:catas_univalle/widgets/register/custom_selectionfield.dart';
import 'package:catas_univalle/widgets/register/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/view_models/add_event_viewmodel.dart';
import 'package:image_picker/image_picker.dart';

class AddEventView extends StatefulWidget {
  const AddEventView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddEventViewState();
  }
}

class _AddEventViewState extends State<AddEventView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AddEventViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Añadir Evento de Cata',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              CustomTextFormField(
                labelText: 'Nombre del Evento',
                onSaved: (value) => viewModel.name = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio.' : null,
              ),
              CustomTextFormField(
                labelText: 'Fecha del Evento',
                readOnly: true,
                onTap: () => viewModel.selectDate(context),
                controller: viewModel.dateController,
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio.' : null,
              ),
              CustomTextFormField(
                labelText: 'Lugar del Evento',
                onSaved: (value) => viewModel.location = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio.' : null,
              ),
              //horas
              CustomTextFormField(
                labelText: 'Link de Lugar del Evento',
                onSaved: (value) => viewModel.locationUrl = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio.' : null,
              ),
              //cliente organizador
              _image == null
                  ? Container(
                      height: 220,
                      color: Colors.grey.shade100,
                      child: const Center(
                          child: Text('No has seleccionado una imagen aún.')))
                  : SizedBox(
                      height: 220,
                      child: Image.file(
                        File(
                          _image!.path,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
              TextButton.icon(
                onPressed: () async {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _image = image;
                      viewModel.logo = File(_image!.path);
                    });
                  }
                },
                icon: const Icon(Icons.image),
                label: const Text('Elegir Imagen del Evento'),
              ),
              CustomTextFormField(
                labelText: 'Descripción del Evento',
                onSaved: (value) => viewModel.about = value ?? '',
                maxLines: 4,
              ),
              CustomTextFormField(
                labelText: 'Link de Formulario',
                onSaved: (value) => viewModel.formUrl = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio.' : null,
              ),
              CustomTextFormField(
                labelText: 'Código del Evento',
                readOnly: true,
                onTap: () => viewModel.randomizeCode(),
                controller: viewModel.codeController,
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio.' : null,
              ),
              CustomSelectionField(
                labelText: 'Restricción de Alergias',
                controller: viewModel.allergiesController,
                onTap: () => viewModel.showAllergiesDialog(context),
              ),
              CustomSelectionField(
                labelText: 'Restricción de Padecimientos',
                controller: viewModel.symptomsController,
                onTap: () => viewModel.showSymptomsDialog(context),
              ),
              CustomNumberInput(
                labelText: 'Cantidad de Jueces',
                controller: viewModel.numberOfJudgesController,
                onSaved: (value) {
                  int numberOfJudges = int.tryParse(value) ?? 0;
                  viewModel.updateNumberOfJudges(numberOfJudges);
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    bool success = await viewModel.addEvent();
                    if (success) {
                      Navigator.of(context).pop();
                    } else {
                      // Handle failure
                    }
                  }
                },
                child: viewModel.isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Registrar Evento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
