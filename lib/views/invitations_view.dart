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
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    _futureEvents = EventService().fetchEventsForJudge(profileViewModel.currentUser!.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Invitaciones',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Event>>(
        future: _futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text("No tienes invitaciones"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final Event event = snapshot.data![index];
                return ListTile(
                  leading: event.imageUrl != null
                      ? Image.network(event.imageUrl, width: 50, height: 50)
                      : null,
                  title: Text(event.name),
                  subtitle: Text(event.date.toString()),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => JudgeEventDetailsView(
                            event: event,
                            judgeId: profileViewModel.currentUser!.uid),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text("No tienes invitaciones"));
          }
        },
      ),
    );
  }
}
