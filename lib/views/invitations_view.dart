import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/view_models/profile_viewmodel.dart';

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
                  leading: event.imageUrl != null ? Image.network(event.imageUrl, width: 50, height: 50) : null,
                  title: Text(event.name),
                  subtitle: Text(event.date.toString()),
                  onTap: () {
                    // Todo: crear una pantalla de detalles del evento con los botones de aceptar o rechazar
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
