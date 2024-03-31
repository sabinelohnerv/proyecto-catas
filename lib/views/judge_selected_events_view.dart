import 'package:catas_univalle/view_models/judge_events_viewmodel.dart';
import 'package:catas_univalle/views/admin_event_details_view.dart';
import 'package:catas_univalle/views/event_form_view.dart'; // Borrar
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';

class JudgeSelectedEventsView extends StatelessWidget {
  final String judgeId;
  const JudgeSelectedEventsView({super.key, required this.judgeId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JudgeEventsViewModel(judgeId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Eventos Seleccionados'),
        ),
        body: Consumer<JudgeEventsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.events.isEmpty) {
              return const Center(child: Text('No hay eventos seleccionados.'));
            }
            return ListView.builder(
              itemCount: viewModel.events.length,
              itemBuilder: (context, index) {
                Event event = viewModel.events[index];
                return ListTile(
                  title: Text(event.name),
                  subtitle: Text(event.date),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AdminEventDetailsView(
                          event: event,
                          isAdmin: false,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
