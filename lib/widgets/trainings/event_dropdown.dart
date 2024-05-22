import 'package:flutter/material.dart';
import 'package:catas_univalle/models/event.dart';

class EventDropdown extends StatefulWidget {
  final List<Event> events;
  final String? selectedEventId;
  final ValueChanged<String?> onChanged;

  const EventDropdown({
    super.key,
    required this.events,
    this.selectedEventId,
    required this.onChanged,
  });

  @override
  _EventDropdownState createState() => _EventDropdownState();
}

class _EventDropdownState extends State<EventDropdown> {
  String? currentSelectedId;

  @override
  void initState() {
    super.initState();
    if (widget.selectedEventId != null && widget.events.any((event) => event.id == widget.selectedEventId)) {
      currentSelectedId = widget.selectedEventId;
    } else if (widget.events.isNotEmpty) {
      currentSelectedId = widget.events.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: currentSelectedId,
      onChanged: (String? newValue) {
        setState(() {
          currentSelectedId = newValue;
        });
        widget.onChanged(newValue);
      },
      items: widget.events.map<DropdownMenuItem<String>>((Event event) {
        return DropdownMenuItem<String>(
          value: event.id,
          child: Text(event.name),
        );
      }).toList(),
      isExpanded: true,
    );
  }
}
