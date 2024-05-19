import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  final String about;

  const AboutSection({super.key, required this.about});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ACERCA",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(about, style: const TextStyle(fontSize: 16)),
          )
        ],
      ),
    );
  }
}
