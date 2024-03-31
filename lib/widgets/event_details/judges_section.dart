import 'package:flutter/material.dart';

import '../../models/event_judge.dart';

class JudgesSection extends StatelessWidget {
  final List<EventJudge> judges;

  const JudgesSection({
    Key? key,
    required this.judges,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: judges
            .map((judge) => Chip(
                  avatar: CircleAvatar(
                    backgroundImage: NetworkImage(judge.imgUrl),
                    backgroundColor: Colors.grey[200],
                  ),
                  label: Text(judge.email),
                  backgroundColor: colorScheme.secondaryContainer,
                ))
            .toList(),
      ),
    );
  }
}
