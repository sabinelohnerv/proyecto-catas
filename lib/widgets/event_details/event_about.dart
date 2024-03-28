import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  final String about;

  const AboutSection({Key? key, required this.about}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 30),
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
