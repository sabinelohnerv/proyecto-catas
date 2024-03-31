import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/client.dart';
import 'package:catas_univalle/view_models/edit_client_viewmodel.dart';
import 'package:catas_univalle/widgets/register/custom_textfield.dart';

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
      appBar: AppBar(
        title: const Text(
          'Editar Cliente',
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
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                initialValue: viewModel.name,
                labelText: "Nombre del Cliente",
                onSaved: (value) => viewModel.name = value ?? "",
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio.' : null,
              ),
              CustomTextFormField(
                initialValue: viewModel.email,
                labelText: "Email",
                onSaved: (value) => viewModel.email = value ?? "",
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio.' : null,
              ),
              const SizedBox(height: 20),
              _logo == null
                  ? (viewModel.logoImgUrl != null &&
                          viewModel.logoImgUrl!.isNotEmpty
                      ? SizedBox(
                          height: 220,
                          width: MediaQuery.sizeOf(context).width,
                          child: Image.network(
                            viewModel.logoImgUrl!,
                            fit: BoxFit.cover,
                          ))
                      : Container(
                          height: 220,
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: Text('No has seleccionado un logo aún.'),
                          )))
                  : SizedBox(
                      height: 220,
                      width: MediaQuery.sizeOf(context).width,
                      child: Image.file(
                        _logo!,
                        fit: BoxFit.cover,
                      )),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Elegir logo'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    viewModel.updateClient(_logo).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cambios guardados correctamente.'),
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
            ],
          ),
        ),
      ),
    );
  }
}
