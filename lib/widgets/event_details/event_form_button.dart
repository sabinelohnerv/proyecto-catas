import 'package:flutter/material.dart';

class TakeFormButton extends StatelessWidget {
  final VoidCallback onPressed;

  const TakeFormButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: FilledButton.icon(
          onPressed: onPressed,
          label: const Text(
            'Tomar Cuestionario',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          icon: const Icon(Icons.format_list_bulleted),
        ),
      ),
    );
  }
}
