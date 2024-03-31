import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/view_models/profile_viewmodel.dart';
import 'package:catas_univalle/views/judge_event_details_view.dart';

class InvitationsView extends StatefulWidget {
  const InvitationsView({Key? key}) : super(key: key);

  @override
  _InvitationsViewState createState() => _InvitationsViewState();
}

class _InvitationsViewState extends State<InvitationsView> {
  late Future<List<Event>> _futureEvents;

  @override
  void initState() {
    super.initState();
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    _futureEvents = EventService().fetchEventsForJudge(profileViewModel.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Invitaciones', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Event>>(
        future: _futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView(
              children: snapshot.data!.map((event) => Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(event.imageUrl),
                    radius: 25,
                  ),
                  title: Text(event.name, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  subtitle: Text(event.date, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => JudgeEventDetailsView(event: event, judgeId: Provider.of<ProfileViewModel>(context, listen: false).currentUser!.uid))),
                ),
              )).toList(),
            );
          } else {
            return const Center(child: Text("No tienes invitaciones"));
          }
        },
      ),
    );
  }
}
