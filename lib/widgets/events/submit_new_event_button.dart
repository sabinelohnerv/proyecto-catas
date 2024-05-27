// ignore_for_file: use_build_context_synchronously

import 'package:catas_univalle/view_models/add_event_viewmodel.dart';
import 'package:flutter/material.dart';

class SubmitNewEventButton extends StatelessWidget {
  const SubmitNewEventButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.viewModel,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final AddEventViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (!viewModel.validateTime()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'La hora de fin debe ser posterior a la hora de inicio.'),
                ),
              );
              return;
            }
            _formKey.currentState!.save();
            bool success = await viewModel.addEvent();
            if (success) {
              viewModel.resetData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Evento registrado correctamente.'),
                  backgroundColor: Color.fromARGB(255, 97, 160, 117),
                ),
              );
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop();
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error al registrar el evento.'),
                  backgroundColor: Color.fromARGB(255, 197, 91, 88),
                ),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        child: viewModel.isSaving
            ? const CircularProgressIndicator()
            : const Text(
                'Registrar Evento',
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}
