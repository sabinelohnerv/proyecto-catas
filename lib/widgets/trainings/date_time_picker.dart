import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  final ValueChanged<DateTime?> onDateSelected;
  final ValueChanged<TimeOfDay?> onTimeSelected;
  final bool isStartTime;

  const DateTimePicker({
    super.key,
    required this.onDateSelected,
    required this.onTimeSelected,
    this.isStartTime = true,
  });

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateSelected(picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
      widget.onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.isStartTime ? "Hora de Inicio" : "Hora de Fin"),
          subtitle: Text(_selectedTime?.format(context) ?? 'No seleccionada'),
          onTap: _selectTime,
        ),
        ListTile(
          title: const Text("Seleccionar Fecha"),
          subtitle: Text(_selectedDate?.toString() ?? 'No seleccionada'),
          onTap: _selectDate,
        ),
      ],
    );
  }
}
