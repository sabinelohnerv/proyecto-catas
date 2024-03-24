import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/view_models/admin_event_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminEventDetailsView extends StatelessWidget {
  final Event event;

  const AdminEventDetailsView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(event.name),
            ElevatedButton(
              onPressed: () {
                Provider.of<AdminEventDetailsViewModel>(context, listen: false)
                    .navigateToSelectJudges(context, event);
              },
              child: const Text('Seleccionar Jueces')
            )
          ],
        )
      ),
    );
  }
}
