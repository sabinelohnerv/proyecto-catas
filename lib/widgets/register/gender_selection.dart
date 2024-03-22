import 'package:flutter/material.dart';

class GenderSelectionWidget extends StatefulWidget {
  final String groupValue;
  final Function(String) onChanged;

  const GenderSelectionWidget({
    super.key,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  State<GenderSelectionWidget> createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Sexo: ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: ListTile(
              title: const Text('M'),
              leading: Radio<String>(
                value: 'M',
                groupValue: widget.groupValue,
                onChanged: (value) => widget.onChanged(value!),
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              title: const Text('F'),
              leading: Radio<String>(
                value: 'F',
                groupValue: widget.groupValue,
                onChanged: (value) => widget.onChanged(value!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
