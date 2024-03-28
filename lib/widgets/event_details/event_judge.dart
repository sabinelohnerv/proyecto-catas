import 'package:flutter/material.dart';

class SelectJudgesButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SelectJudgesButton({Key? key, required this.onPressed})
      : super(key: key);

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
