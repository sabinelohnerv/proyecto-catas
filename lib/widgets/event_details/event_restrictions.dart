import 'package:flutter/material.dart';

class RestrictionsSection extends StatelessWidget {
  final List<String> restrictions;
  final String title;

  const RestrictionsSection({
    Key? key,
    required this.restrictions,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildChips(context, restrictions),
        ],
      ),
    );
  }

  Widget _buildChips(BuildContext context, List<String> restrictions) {
    var colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 10.0,
      runSpacing: 5.0,
      children: restrictions
          .map((restriction) => Chip(
                label: Text(restriction),
                backgroundColor: colorScheme.secondaryContainer,
              ))
          .toList(),
    );
  }
}
