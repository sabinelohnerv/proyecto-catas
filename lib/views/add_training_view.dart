import 'package:flutter/material.dart';
import 'package:catas_univalle/widgets/trainings/training_form.dart';

class AddTrainingView extends StatelessWidget {
  final String eventId;

  AddTrainingView({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Capacitación', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: TrainingForm(eventId: eventId),
      ),
    );
  }
}
