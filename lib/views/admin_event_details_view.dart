import 'package:catas_univalle/models/event.dart';
import 'package:flutter/material.dart';

class AdminEventDetailsView extends StatelessWidget {
  final Event event;

  const AdminEventDetailsView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(event.name)),
    );
  }
}
