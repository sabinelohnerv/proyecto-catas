import 'package:flutter/material.dart';

class AttendanceStamp extends StatelessWidget {
  const AttendanceStamp({super.key, required this.attendanceStatus});

  final String attendanceStatus;

  @override
  Widget build(BuildContext context) {
    String path = _getStatusImage(attendanceStatus);
    String imagePath = 'assets/images/$path.png';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ASISTENCIA",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(
            child: Image.asset(
              imagePath,
              width: 220,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusImage(String status) {
    switch (status) {
      case 'PRESENTE':
        return 'p-stamp';
      case 'AUSENTE':
        return 'f-stamp';
      case 'PENDIENTE':
        return 'e-stamp';
      default:
        return 'p-stamp';
    }
  }
}
