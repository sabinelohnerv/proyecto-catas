import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/view_models/judge_events_viewmodel.dart';
import 'package:catas_univalle/views/admin_event_details_view.dart';

class JudgeSelectedEventsView extends StatelessWidget {
  final String judgeId;
  const JudgeSelectedEventsView({Key? key, required this.judgeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JudgeEventsViewModel(judgeId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Eventos Aceptados', style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Consumer<JudgeEventsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.events.isEmpty) {
              return const Center(child: Text('No has aceptado eventos aún.'));
            }
            return ListView.builder(
              itemCount: viewModel.events.length,
              itemBuilder: (context, index) {
                Event event = viewModel.events[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(event.imageUrl),
                      radius: 25,
                    ),
                    title: Text(event.name, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                    subtitle: Text(event.date, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AdminEventDetailsView(event: event, isAdmin: false),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
