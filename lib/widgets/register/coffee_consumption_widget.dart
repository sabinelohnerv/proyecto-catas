import 'package:catas_univalle/widgets/register/custom_selectfield.dart';
import 'package:flutter/material.dart';

class CoffeeConsumptionWidget extends StatelessWidget {
  final String? selectedOption;
  final Function(String?) onChanged;
  final List<String> options;

  const CoffeeConsumptionWidget({
    super.key,
    required this.selectedOption,
    required this.onChanged,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSelectField<String>(
      value: selectedOption,
      items: options,
      labelText: 'Consumo de café',
      onChanged: onChanged,
      itemLabelBuilder: (value) => value,
    );
  }
}
