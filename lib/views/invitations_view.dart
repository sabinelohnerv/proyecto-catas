import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/models/event_judge.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/view_models/profile_viewmodel.dart';
import 'package:catas_univalle/views/judge_event_details_view.dart';
import 'package:catas_univalle/widgets/events/invitations_card.dart';

class InvitationsView extends StatefulWidget {
  const InvitationsView({Key? key}) : super(key: key);

  @override
  _InvitationsViewState createState() => _InvitationsViewState();
}

class _InvitationsViewState extends State<InvitationsView> {
  late Future<List<Event>> _futureEvents;
  String _filter = 'all'; // all, accepted, rejected, pending

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    setState(() {
      _futureEvents = EventService().fetchEventsForJudge(profileViewModel.currentUser!.uid);
    });
  }

  void _changeFilter(String newFilter) {
    setState(() {
      _filter = newFilter;
      _loadEvents();
    });
  }

  String _mapStateToText(String state) {
    switch (state.toLowerCase()) {
      case 'accepted':
        return 'aceptado';
      case 'rejected':
        return 'rechazado';
      case 'pending':
        return 'pendiente';
      default:
        return 'pendiente';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Invitaciones', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _changeFilter,
            icon: const Icon(Icons.tune),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'all', child: Text('Todos')),
              const PopupMenuItem<String>(value: 'accepted', child: Text('Aceptados')),
              const PopupMenuItem<String>(value: 'rejected', child: Text('Rechazados')),
              const PopupMenuItem<String>(value: 'pending', child: Text('Pendientes')),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Event>>(
        future: _futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            var filteredEvents = snapshot.data!.where((event) {
              final judgeState = event.eventJudges
                  .firstWhere(
                    (judge) => judge.id == Provider.of<ProfileViewModel>(context, listen: false).currentUser!.uid,
                    orElse: () => EventJudge(id: '', name: '', email: '', state: 'pending', imgUrl: ''),
                  )
                  .state;
              return _filter == 'all' || _mapStateToText(judgeState) == _mapStateToText(_filter);
            }).toList();
            return ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                Event event = filteredEvents[index];
                final judgeState = event.eventJudges
                    .firstWhere(
                      (judge) => judge.id == Provider.of<ProfileViewModel>(context, listen: false).currentUser!.uid,
                      orElse: () => EventJudge(id: '', name: '', email: '', state: 'pending', imgUrl: ''),
                    )
                    .state;
                final stateText = _mapStateToText(judgeState);
                return InvitationsCard(
                  event: event,
                  state: stateText,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JudgeEventDetailsView(event: event, judgeId: Provider.of<ProfileViewModel>(context, listen: false).currentUser!.uid),
                    ),
                  ).then((_) => _loadEvents()),
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
