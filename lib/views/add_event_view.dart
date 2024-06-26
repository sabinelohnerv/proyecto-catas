import 'dart:io';
import 'package:catas_univalle/models/client.dart';
import 'package:catas_univalle/widgets/events/submit_new_event_button.dart';
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
  void initState() {
    super.initState();
    final viewModel = Provider.of<AddEventViewModel>(context, listen: false);
    viewModel.fetchClients();
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
              "Agregar Evento",
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
            centerTitle: true,
          ),
        ],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
            child: Form(
              key: _formKey,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Datos Generales del Evento',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                    CustomTextFormField(
                      labelText: 'Nombre del Evento',
                      prefixIcon: const Icon(Icons.event),
                      onSaved: (value) => viewModel.name = value ?? '',
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                    CustomTextFormField(
                      labelText: 'Descripción del Evento',
                      prefixIcon: const Icon(Icons.description),
                      onSaved: (value) => viewModel.about = value ?? '',
                      maxLines: 4,
                    ),
                    _image == null
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                            child: Container(
                              height: 220,
                              color: Colors.grey.shade100,
                              child: const Center(
                                  child: Icon(
                                Icons.no_photography_rounded,
                                color: Colors.grey,
                                size: 50,
                              )),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                            child: SizedBox(
                              height: 220,
                              width: MediaQuery.sizeOf(context).width,
                              child: Image.file(
                                File(
                                  _image!.path,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    TextButton.icon(
                      onPressed: () async {
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            _image = image;
                            viewModel.logo = File(_image!.path);
                          });
                        }
                      },
                      icon: const Icon(Icons.image),
                      label: const Text('Elegir imagen para el evento'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
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
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.business_center),
                          labelText: 'Anfitrión',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(0, 15, 10, 15),
                        ),
                      ),
                    ),
                    CustomNumberInput(
                      prefixIcon: const Icon(Icons.people),
                      labelText: 'Cantidad de Jueces',
                      controller: viewModel.numberOfJudgesController,
                      onSaved: (value) {
                        int numberOfJudges = int.tryParse(value) ?? 0;
                        viewModel.updateNumberOfJudges(numberOfJudges);
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Text(
                        'Ejecución del Evento',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                    CustomTextFormField(
                      labelText: 'Fecha del Evento',
                      prefixIcon: const Icon(Icons.date_range),
                      readOnly: true,
                      onTap: () => viewModel.selectDate(context),
                      controller: viewModel.dateController,
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            labelText: 'Inicio',
                            prefixIcon: const Icon(Icons.access_time),
                            readOnly: true,
                            onTap: () => viewModel.selectStartTime(context),
                            controller: viewModel.startTimeController,
                            validator: (value) => value!.isEmpty
                                ? 'Este campo es obligatorio.'
                                : null,
                          ),
                        ),
                        Expanded(
                          child: CustomTextFormField(
                            labelText: 'Fin',
                            prefixIcon: const Icon(Icons.timer_off),
                            readOnly: true,
                            onTap: () => viewModel.selectEndTime(context),
                            controller: viewModel.endTimeController,
                            validator: (value) => value!.isEmpty
                                ? 'Este campo es obligatorio.'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    CustomTextFormField(
                      labelText: 'Lugar del Evento',
                      prefixIcon: const Icon(Icons.location_on),
                      onSaved: (value) => viewModel.location = value ?? '',
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Text(
                        'Formulario del Evento',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                    CustomTextFormField(
                      labelText: 'Link de Formulario',
                      prefixIcon: const Icon(Icons.link),
                      onSaved: (value) => viewModel.formUrl = value ?? '',
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                    CustomTextFormField(
                      labelText: 'Código de Habilitación',
                      prefixIcon: const Icon(Icons.abc_sharp),
                      readOnly: true,
                      onTap: () => viewModel.randomizeCode(),
                      controller: viewModel.codeController,
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Text(
                        'Restricciones del Evento',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                    CustomSelectionField(
                      prefixIcon: const Icon(Icons.list),
                      labelText: 'Restricción de Alergias',
                      controller: viewModel.allergiesController,
                      onTap: () => viewModel.showAllergiesDialog(context),
                    ),
                    CustomSelectionField(
                      prefixIcon: const Icon(Icons.list),
                      labelText: 'Restricción de Padecimientos',
                      controller: viewModel.symptomsController,
                      onTap: () => viewModel.showSymptomsDialog(context),
                    ),
                    SubmitNewEventButton(
                        formKey: _formKey, viewModel: viewModel),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
