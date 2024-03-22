import 'package:flutter/material.dart';

class SmokingSelectionWidget extends StatefulWidget {
  final bool smokes;
  final Function(bool) onChanged;

  const SmokingSelectionWidget({
    super.key,
    required this.smokes,
    required this.onChanged,
  });

  @override
  State<SmokingSelectionWidget> createState() => _SmokingSelectionWidgetState();
}

class _SmokingSelectionWidgetState extends State<SmokingSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Text('¿Fuma?: ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: ListTile(
              title: const Text('✓'),
              leading: Radio<bool>(
                value: true,
                groupValue: widget.smokes,
                onChanged: (bool? value) {
                  widget.onChanged(value!);
                },
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              title: const Text('✗'),
              leading: Radio<bool>(
                value: false,
                groupValue: widget.smokes,
                onChanged: (bool? value) {
                  widget.onChanged(value!);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
