import 'dart:io';
import 'package:catas_univalle/models/client.dart';
import 'package:catas_univalle/view_models/add_client_viewmodel.dart';
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
  String _name = '';
  String _email = '';
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_logo != null) {
        viewModel.addClient(_name, _email, _logo!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cliente añadido correctamente.'),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al crear el cliente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Nombre del Cliente'),
                  validator: (value) => value!.isEmpty
                      ? 'Por favor ingresa un nombre para el cliente.'
                      : null,
                  onSaved: (value) => _name = value!,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Email del Cliente'),
                  validator: (value) => (value!.isEmpty || !value.contains('@'))
                      ? 'Por favor ingresa un email válido.'
                      : null,
                  onSaved: (value) => _email = value!,
                ),
                const SizedBox(height: 20),
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
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
