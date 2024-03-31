import 'package:catas_univalle/widgets/events/event_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/view_models/judge_events_viewmodel.dart';
import 'package:catas_univalle/views/admin_event_details_view.dart';

import '../widgets/events/admin_event_card.dart';

class JudgeSelectedEventsView extends StatelessWidget {
  final String judgeId;
  const JudgeSelectedEventsView({super.key, required this.judgeId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JudgeEventsViewModel(judgeId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Eventos de Cata Aceptados',
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
        body: Consumer<JudgeEventsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.events.isEmpty) {
              return const Center(child: Text('No has aceptado catas aún.'));
            }
            return ListView.builder(
              itemCount: viewModel.events.length,
              itemBuilder: (context, index) {
                Event event = viewModel.events[index];
                return AdminEventCard(
                    event: event,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AdminEventDetailsView(
                              event: event, isAdmin: false),
                        ),
                      );
                    });
              },
            );
          },
        ),
      ),
    );
  }
}
