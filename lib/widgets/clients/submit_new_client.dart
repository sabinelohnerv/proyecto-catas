import 'dart:io';
import 'package:catas_univalle/view_models/add_client_viewmodel.dart';
import 'package:flutter/material.dart';

class SubmitNewClient extends StatelessWidget {
  const SubmitNewClient({
    super.key,
    required GlobalKey<FormState> formKey,
    required File? logo,
    required this.viewModel,
    required String name,
    required String email,
  }) : _formKey = formKey, _logo = logo, _name = name, _email = email;

  final GlobalKey<FormState> _formKey;
  final File? _logo;
  final AddClientViewModel viewModel;
  final String _name;
  final String _email;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
    
          if (_logo != null) {
            viewModel.addClient(viewModel.name, viewModel.email, _logo);
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
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      child: const Text('Guardar'),
    );
  }
}
