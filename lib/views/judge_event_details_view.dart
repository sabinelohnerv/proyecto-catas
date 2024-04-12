import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';

class JudgeEventDetailsView extends StatelessWidget {
  final Event event;
  final String judgeId;

  const JudgeEventDetailsView({Key? key, required this.event, required this.judgeId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primaryColor = theme.colorScheme.primary;

    void acceptInvitation() async {
      try {
        final eventService = Provider.of<EventService>(context, listen: false);
        await eventService.updateJudgeStatus(event.id, judgeId, 'accepted');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invitación aceptada'), backgroundColor: Colors.green));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al aceptar la invitación: $e'), backgroundColor: Colors.red));
      }
    }

    void rejectInvitation() async {
      try {
        final eventService = Provider.of<EventService>(context, listen: false);
        await eventService.updateJudgeStatus(event.id, judgeId, 'rejected');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invitación rechazada'), backgroundColor: Colors.red));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al rechazar la invitación: $e'), backgroundColor: Colors.red));
      }
    }

    Widget infoSection(String title, String content) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "$title: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                content,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }

    List<Widget> buildRestrictions(List<String> restrictions, String title) {
      if (restrictions.isEmpty) {
        return [];
      }
      return [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor),
          ),
        ),
        ...restrictions.map(
          (restriction) => Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(restriction),
          ),
        ).toList(),
      ];
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 300, 
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(event.imageUrl),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: primaryColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 320),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.name,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: primaryColor),
                            ),
                            infoSection("Fecha", event.date),
                            infoSection("Hora", "${event.start} - ${event.end}"),
                            infoSection("Ubicación", event.location),
                            ...buildRestrictions(event.allergyRestrictions, "Alergias"),
                            ...buildRestrictions(event.symptomRestrictions, "Síntomas"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 26), 
            decoration: BoxDecoration(
              color: primaryColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.black12,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.white, size: 30),
                  onPressed: acceptInvitation,
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: rejectInvitation,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
