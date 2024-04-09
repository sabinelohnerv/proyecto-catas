import 'package:catas_univalle/widgets/trainings/training_event_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/event.dart';
import '/view_models/cata_events_viewmodel.dart'; 

class AddTrainingEventView extends StatefulWidget {
  const AddTrainingEventView({Key? key}) : super(key: key);

  @override
  _AddTrainingEventViewState createState() => _AddTrainingEventViewState();
}

class _AddTrainingEventViewState extends State<AddTrainingEventView> {
  @override
  void initState() {
    super.initState();
    Provider.of<CataEventsViewModel>(context, listen: false).loadCataEvents();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Nueva Capacitación',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: TrainingEventForm(),
        ),
      ),
    );
  }
}
