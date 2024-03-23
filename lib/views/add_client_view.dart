import 'dart:io';
import 'package:catas_univalle/functions/util.dart';
import 'package:catas_univalle/view_models/add_client_viewmodel.dart';
import 'package:catas_univalle/widgets/clients/submit_new_client.dart';
import 'package:catas_univalle/widgets/register/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddClientView extends StatefulWidget {
  const AddClientView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddClientViewState();
  }
}

class _AddClientViewState extends State<AddClientView> {
  final _formKey = GlobalKey<FormState>();
  File? _logo;
  final picker = ImagePicker();
  final AddClientViewModel viewModel = AddClientViewModel();

  Future getImage() async {
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
          'Añadir Cliente',
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CustomTextFormField(
                  labelText: 'Nombre del Cliente',
                  onSaved: (value) => viewModel.name = value ?? '',
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio.' : null,
                ),
                CustomTextFormField(
                  labelText: 'Email',
                  onSaved: (value) => viewModel.email = value ?? '',
                  validator: (value) {
                    if ((value == null ||
                        value.trim().isEmpty ||
                        !isValidEmail(value))) {
                      return 'Ingresa un email válido.';
                    }
                    return null;
                  },
                ),
                const Text(
                  'Logo del Cliente',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                _logo == null
                    ? Container(
                        height: 220,
                        color: Colors.grey.shade100,
                        child: const Center(
                            child: Text('No has seleccionado un logo aún.')))
                    : SizedBox(
                        height: 220,
                        width: MediaQuery.sizeOf(context).width,
                        child: Image.file(
                          _logo!,
                          fit: BoxFit.cover,
                        )),
                TextButton.icon(
                  onPressed: getImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Elegir logo'),
                ),
                const SizedBox(
                  height: 20,
                ),
                SubmitNewClient(
                    formKey: _formKey,
                    logo: _logo,
                    viewModel: viewModel,
                    name: viewModel.name,
                    email: viewModel.email),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
