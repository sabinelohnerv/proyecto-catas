import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/views/select_judges_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:catas_univalle/models/event_judge.dart';
import 'package:catas_univalle/services/event_service.dart';

class SelectedJudgesViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();
  final Event event;

  Stream<List<EventJudge>>? selectedJudgesStream;

  SelectedJudgesViewModel(this.event) {
    _loadSelectedJudges();
  }

  void _loadSelectedJudges() {
    selectedJudgesStream = _eventService.getSelectedJudgesStream(event.id);
    notifyListeners();
  }

  void navigateToSelectJudges(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectJudgesView(
          eventId: event.id,
        ),
      ),
    );
  }

  void resendInvitations(Event event) async {
    if (FirebaseAuth.instance.currentUser == null) {
      print('User is not authenticated.');
      return;
    }

    print(
        'User is authenticated. Attempting to resend invitations for event ${event.id}.');

    var commandDoc =
        FirebaseFirestore.instance.collection('commands').doc('resendCommand');
    try {
      await commandDoc.set({
        'resendInvitations': true,
        'eventId': event.id,
        'timestamp': FieldValue.serverTimestamp()
      });
      print(
          'Command to resend invitations for event ${event.id} updated successfully.');
    } catch (e) {
      print('Error updating command to resend invitations: $e');
    }
  }
}
