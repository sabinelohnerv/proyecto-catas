import 'package:flutter/material.dart';

class SelectJudgesButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SelectJudgesButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: FilledButton(
            onPressed: onPressed, child: const Text('SELECCIONAR JUECES')),
      ),
    );
  }
}
