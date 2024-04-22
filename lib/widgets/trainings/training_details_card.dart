import 'package:catas_univalle/models/training.dart';
import 'package:flutter/material.dart';

class TrainingDetailsCard extends StatelessWidget {
  const TrainingDetailsCard({
    super.key,
    required this.training,
    required this.dayNumber,
    required this.abbreviatedMonth,
  });

  final Training training;
  final String dayNumber;
  final String abbreviatedMonth;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 25, 8, 35),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                training.name,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 28, vertical: 4),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                    ),
                    padding: const EdgeInsets.all(8),
                    width: 60,
                    height: 70,
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context)
                              .style,
                          children: <TextSpan>[
                            TextSpan(
                              text: dayNumber,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                            TextSpan(
                              text: '\n$abbreviatedMonth',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                training.location,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time,),
                            const SizedBox(width: 4.0),
                            Text(
                              '${training.startTime} - ${training.endTime}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
