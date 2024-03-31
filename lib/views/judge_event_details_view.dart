import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';

class JudgeEventDetailsView extends StatelessWidget {
  final Event event;
  final String judgeId;

  const JudgeEventDetailsView({Key? key, required this.event, required this.judgeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color seedColor = theme.colorScheme.primary; 

   void acceptInvitation() async {
  try {
    final eventService = Provider.of<EventService>(context, listen: false);
    await eventService.updateJudgeStatus(event.id, judgeId, 'accepted');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invitación aceptada'), backgroundColor: Colors.green),
    );
  
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al aceptar la invitación: $e'), backgroundColor: Colors.red),
    );
  }
}

void rejectInvitation() async {
  try {
    final eventService = Provider.of<EventService>(context, listen: false);
    await eventService.updateJudgeStatus(event.id, judgeId, 'rejected');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invitación rechazada'), backgroundColor: Colors.red),
    );
    // Opcional: Código para redirigir al usuario o actualizar la UI
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al rechazar la invitación: $e'), backgroundColor: Colors.red),
    );
  }
}


    Widget infoSection(String title, String content) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Text("$title: ", style: theme.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold)),
            Expanded(child: Text(content, style: theme.textTheme.subtitle1)),
          ],
        ),
      );
    }

    List<Widget> buildRestrictions(List<String> restrictions, String title) {
      if (restrictions.isEmpty) return [];
      return [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(title, style: theme.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold)),
        ),
        ...restrictions.map((restriction) => Text(restriction, style: theme.textTheme.bodyText2)).toList(),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(event.name, style: TextStyle(color: Colors.white)),
        backgroundColor: seedColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
                image: DecorationImage(
                  image: NetworkImage(event.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.name, style: theme.textTheme.headline5?.copyWith(fontWeight: FontWeight.bold)),
                  infoSection("Fecha", event.date),
                  infoSection("Hora", "${event.start} - ${event.end}"),
                  infoSection("Ubicación", event.location),
                  ...buildRestrictions(event.allergyRestrictions, "Alergias"),
                  ...buildRestrictions(event.symptomRestrictions, "Síntomas"),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: acceptInvitation,
                        child: Text('Aceptar', style: TextStyle(color: Colors.white, fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: seedColor,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: rejectInvitation,
                        child: Text('Rechazar', style: TextStyle(color: Colors.white, fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: seedColor,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
