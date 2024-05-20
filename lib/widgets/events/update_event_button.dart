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
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 6),
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
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error al actualizar el evento.'),
                  backgroundColor: Colors.red,
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
            : const Text('ACTUALIZAR EVENTO'),
      ),
    );
  }
}
