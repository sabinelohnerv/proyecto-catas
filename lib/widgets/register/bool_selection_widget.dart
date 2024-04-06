import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BoolSelectionWidget extends StatefulWidget {
  final bool changingValue;
  final String labelText;
  final Function(bool) onChanged;

  const BoolSelectionWidget({
    super.key,
    required this.changingValue,
    required this.labelText,
    required this.onChanged,
  });

  @override
  State<BoolSelectionWidget> createState() => _BoolSelectionWidgetState();
}

class _BoolSelectionWidgetState extends State<BoolSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Visibility(
            visible: widget.labelText != '',
            child: Expanded(
              child: Text(
                widget.labelText,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.clip,
                maxLines: 2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              title: const Text('✓'),
              leading: Radio<bool>(
                value: true,
                groupValue: widget.changingValue,
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
                groupValue: widget.changingValue,
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
