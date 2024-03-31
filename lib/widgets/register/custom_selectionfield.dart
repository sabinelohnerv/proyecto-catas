import 'package:flutter/material.dart';

class CustomSelectionField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final VoidCallback onTap;

  const CustomSelectionField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          label: Text(labelText),
          border: const OutlineInputBorder(),
          hintText: 'Toca para seleccionar',
        ),
        onTap: onTap,
      ),
    );
  }
}
