import 'dart:io';
import 'package:catas_univalle/widgets/register/custom_editfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/client.dart';
import 'package:catas_univalle/view_models/edit_client_viewmodel.dart';

class EditClientView extends StatefulWidget {
  final Client client;

  const EditClientView({super.key, required this.client});

  @override
  State<StatefulWidget> createState() {
    return _EditClientViewState();
  }
}

class _EditClientViewState extends State<EditClientView> {
  final _formKey = GlobalKey<FormState>();
  late EditClientViewModel viewModel;
  File? _logo;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<EditClientViewModel>(context, listen: false);
    viewModel.loadClient(widget.client);
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logo = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxisScrolled) => [
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
              "Editar Anfitrión",
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            ),
            centerTitle: true,
          ),
        ],
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
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
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      child: Text(
                        'Datos del Anfitrión',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    CustomEditFormField(
                      initialValue: viewModel.name,
                      labelText: "Nombre del Anfitrión",
                      prefixIcon: const Icon(Icons.assignment_ind),
                      onSaved: (value) => viewModel.name = value ?? "",
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                    CustomEditFormField(
                      initialValue: viewModel.email,
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      onSaved: (value) => viewModel.email = value ?? "",
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      child: Text(
                        'Logo del Anfitrión',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _logo == null
                        ? (viewModel.logoImgUrl != null &&
                                viewModel.logoImgUrl!.isNotEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: SizedBox(
                                    height: 220,
                                    width: MediaQuery.sizeOf(context).width,
                                    child: Image.network(
                                      viewModel.logoImgUrl!,
                                      fit: BoxFit.cover,
                                    )),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Container(
                                    height: 220,
                                    color: Colors.grey.shade100,
                                    child: const Center(
                                      child: Text(
                                          'No has seleccionado un logo aún.'),
                                    )),
                              ))
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                                height: 220,
                                width: MediaQuery.sizeOf(context).width,
                                child: Image.file(
                                  _logo!,
                                  fit: BoxFit.cover,
                                )),
                          ),
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Elegir logo'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 20, 28, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            viewModel.updateClient(_logo).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Cambios guardados correctamente.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Guardar Cambios'),
                      ),
                    ),
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
