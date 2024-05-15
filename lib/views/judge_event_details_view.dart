import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/widgets/event_details/event_about.dart';
import 'package:catas_univalle/widgets/event_details/event_details.dart';
import 'package:catas_univalle/widgets/event_details/event_header.dart';
import 'package:catas_univalle/widgets/event_details/event_restrictions.dart';

class JudgeEventDetailsView extends StatelessWidget {
  final Event event;
  final String judgeId;

  const JudgeEventDetailsView({
    Key? key,
    required this.event,
    required this.judgeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primaryColor = theme.colorScheme.primary;
    final size = MediaQuery.of(context).size;

    void acceptInvitation() async {
      try {
        final eventService = Provider.of<EventService>(context, listen: false);
        await eventService.updateJudgeStatus(event.id, judgeId, 'accepted');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invitación aceptada'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al aceptar la invitación: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    void rejectInvitation() async {
      try {
        final eventService = Provider.of<EventService>(context, listen: false);
        await eventService.updateJudgeStatus(event.id, judgeId, 'rejected');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invitación rechazada'),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al rechazar la invitación: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              EventImage(imageUrl: event.imageUrl),
              Positioned(
                top: size.height * 0.05,
                left: 16,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: primaryColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.06,
                      color: primaryColor,
                    ),
                  ),
                  EventDetail(icon: Icons.calendar_today, text: event.date),
                  EventDetail(icon: Icons.access_time, text: "${event.start} - ${event.end}"),
                  EventDetail(icon: Icons.location_on, text: event.location),
                  if (event.allergyRestrictions.isNotEmpty)
                    RestrictionsSection(
                      restrictions: event.allergyRestrictions,
                      title: "Alergias",
                    ),
                  if (event.symptomRestrictions.isNotEmpty)
                    RestrictionsSection(
                      restrictions: event.symptomRestrictions,
                      title: "Síntomas",
                    ),
                  AboutSection(about: event.about),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.width * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: acceptInvitation,
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                'ACEPTAR',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.015),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: rejectInvitation,
              icon: const Icon(Icons.close, color: Colors.white),
              label: const Text(
                'RECHAZAR',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.015),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
