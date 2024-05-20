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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40))),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                viewModel.resetData();
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text(
              "Editar Evento",
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
            centerTitle: true,
          ),
        ],
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
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
                  CustomTextFormField(
                    labelText: 'Nombre del Evento',
                    prefixIcon: const Icon(Icons.event),
                    controller: viewModel.nameController,
                    onSaved: (value) => viewModel.name = value,
                    validator: (value) =>
                        value!.isEmpty ? 'Este campo es obligatorio.' : null,
                  ),
                  CustomTextFormField(
                    controller: viewModel.dateController,
                    labelText: 'Fecha del Evento',
                    prefixIcon: const Icon(Icons.calendar_today),
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
                          prefixIcon: const Icon(Icons.timer),
                          readOnly: true,
                          onTap: () => viewModel.selectStartTime(context),
                          validator: (value) => value!.isEmpty
                              ? 'Este campo es obligatorio.'
                              : null,
                        ),
                      ),
                      Expanded(
                        child: CustomTextFormField(
                          controller: viewModel.endTimeController,
                          labelText: 'Hora de Finalización',
                          prefixIcon: const Icon(Icons.timer_off),
                          readOnly: true,
                          onTap: () => viewModel.selectEndTime(context),
                          validator: (value) => value!.isEmpty
                              ? 'Este campo es obligatorio.'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  CustomTextFormField(
                    controller: viewModel.locationController,
                    labelText: 'Lugar del Evento',
                    prefixIcon: const Icon(Icons.place),
                    onSaved: (value) => viewModel.location = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? 'Este campo es obligatorio.' : null,
                  ),
                  CustomTextFormField(
                    controller: viewModel.locationUrlController,
                    labelText: 'Link de Lugar del Evento',
                    prefixIcon: const Icon(Icons.link),
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
                      child: const Icon(
                        Icons.photo_size_select_actual,
                        color: Colors.grey,
                        size: 60,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextButton.icon(
                      icon: const Icon(Icons.image),
                      label: const Text('Elegir Imagen'),
                      onPressed: () async {
                        final XFile? newImage = await _picker.pickImage(
                            source: ImageSource.gallery);
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
                    prefixIcon: const Icon(Icons.link),
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
        ),
      ),
    );
  }
}
