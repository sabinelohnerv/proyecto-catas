import 'package:catas_univalle/view_models/admin_event_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventActionButtons extends StatelessWidget {
  const EventActionButtons({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<AdminEventDetailsViewModel>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.onInverseSurface),
            onPressed: () async {
              await viewModel.navigateToEditEvent(context, eventId);
            },
            child: const Icon(Icons.edit),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.onInverseSurface),
            onPressed: () async {
              bool confirmDeletion = await showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text('Confirmar eliminación'),
                        content: const Text(
                            '¿Estás seguro de querer eliminar este evento?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      );
                    },
                  ) ??
                  false;

              if (confirmDeletion) {
                final viewModel = Provider.of<AdminEventDetailsViewModel>(
                    context,
                    listen: false);
                bool success =
                    await viewModel.deleteCurrentEvent(context, eventId);
                if (success) {
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Error al eliminar el evento")),
                  );
                }
              }
            },
            child: const Icon(Icons.delete),
          ),
        ),
      ],
    );
  }
}
