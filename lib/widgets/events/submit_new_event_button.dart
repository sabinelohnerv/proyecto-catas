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
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 6),
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
                  backgroundColor: Colors.green,
                ),
              );
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop();
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error al registrar el evento.'),
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
        child: viewModel.isSaving
            ? const CircularProgressIndicator()
            : const Text('Registrar Evento'),
      ),
    );
  }
}
