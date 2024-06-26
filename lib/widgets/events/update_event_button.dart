// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../view_models/add_event_viewmodel.dart';

class UpdateEventButton extends StatelessWidget {
  final String eventId;
  final GlobalKey<FormState> _formKey;
  final AddEventViewModel viewModel;

  const UpdateEventButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.viewModel,
    required this.eventId,
  }) : _formKey = formKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
      child: ElevatedButton(
        onPressed: () async {
          viewModel.validateAndConvertTimes();
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
            bool success = await viewModel.updateEvent(eventId);
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Evento actualizado correctamente.'),
                  backgroundColor: Color.fromARGB(255, 97, 160, 117),
                ),
              );
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error al actualizar el evento.'),
                  backgroundColor: Color.fromARGB(255, 197, 91, 88),
                ),
              );
              Navigator.of(context).pop(false);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        child: viewModel.isSaving
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text(
                'Actualizar Evento',
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}
