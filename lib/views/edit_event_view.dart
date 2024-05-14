import 'dart:io';
import 'package:catas_univalle/models/client.dart';
import 'package:catas_univalle/widgets/events/update_event_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:catas_univalle/view_models/add_event_viewmodel.dart';
import 'package:catas_univalle/widgets/register/custom_selectionfield.dart';
import 'package:catas_univalle/widgets/register/custom_textfield.dart';

class EditEventView extends StatefulWidget {
  final String eventId;

  const EditEventView({super.key, required this.eventId});

  @override
  State<StatefulWidget> createState() {
    return _EditEventViewState();
  }
}

class _EditEventViewState extends State<EditEventView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => {
          Provider.of<AddEventViewModel>(context, listen: false)
            ..loadEvent(widget.eventId)
        });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AddEventViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Evento',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            viewModel.resetData();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                labelText: 'Nombre del Evento',
                controller: viewModel.nameController,
                onSaved: (value) => viewModel.name = value,
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio.' : null,
              ),
              CustomTextFormField(
                controller: viewModel.dateController,
                labelText: 'Fecha del Evento',
                readOnly: true,
                onTap: () => viewModel.selectDate(context),
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio.' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: viewModel.startTimeController,
                      labelText: 'Hora de Inicio',
                      readOnly: true,
                      onTap: () => viewModel.selectStartTime(context),
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                  ),
                  Expanded(
                    child: CustomTextFormField(
                      controller: viewModel.endTimeController,
                      labelText: 'Hora de Finalización',
                      readOnly: true,
                      onTap: () => viewModel.selectEndTime(context),
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                  ),
                ],
              ),
              CustomTextFormField(
                controller: viewModel.locationController,
                labelText: 'Lugar del Evento',
                onSaved: (value) => viewModel.location = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio.' : null,
              ),
              CustomTextFormField(
                controller: viewModel.locationUrlController,
                labelText: 'Link de Lugar del Evento',
                onSaved: (value) => viewModel.locationUrl = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio.' : null,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownButtonFormField<Client>(
                  value: viewModel.client,
                  onChanged: (Client? newValue) {
                    if (newValue != null) {
                      viewModel.selectClient(newValue);
                    }
                  },
                  items: viewModel.clients
                      .map<DropdownMenuItem<Client>>((Client client) {
                    return DropdownMenuItem<Client>(
                      value: client,
                      child: Text(client.name),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Cliente',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              if (viewModel.currentImageUrl != null)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.network(viewModel.currentImageUrl!,
                      height: 200, fit: BoxFit.cover),
                )
              else
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.photo_size_select_actual,
                    color: Colors.grey[600],
                    size: 60,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('Elegir Imagen'),
                  onPressed: () async {
                    final XFile? newImage =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (newImage != null) {
                      await viewModel.updateEventImage(
                          File(newImage.path), widget.eventId);
                    }
                  },
                ),
              ),
              CustomTextFormField(
                labelText: 'Descripción del Evento',
                controller: viewModel.descriptionController,
                onSaved: (value) => viewModel.about = value,
                maxLines: 4,
              ),
              CustomTextFormField(
                labelText: 'Link del Formulario',
                controller: viewModel.linkController,
                onSaved: (value) => viewModel.formUrl = value,
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
              UpdateEventButton(
                formKey: _formKey,
                viewModel: viewModel,
                eventId: widget.eventId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
