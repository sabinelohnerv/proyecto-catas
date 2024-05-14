import 'package:catas_univalle/functions/util.dart';
import 'package:flutter/material.dart';
import 'package:catas_univalle/models/event.dart';

class TrainingEventCard extends StatelessWidget {
  final Event event;
  final int numberOfTrainings;
  final VoidCallback onTap;

  const TrainingEventCard(
      {super.key,
      required this.event,
      required this.onTap,
      required this.numberOfTrainings});

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDateToWrittenDate(event.date);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.16,
              height: MediaQuery.of(context).size.width * 0.16,
              decoration: BoxDecoration(
                image: event.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(event.imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: event.imageUrl.isNotEmpty
                    ? Colors.transparent
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: event.imageUrl.isEmpty
                  ? const Icon(Icons.business, color: Colors.white)
                  : null,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      event.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              width: MediaQuery.of(context).size.width * 0.07,
              height: MediaQuery.of(context).size.width * 0.07,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  numberOfTrainings.toString(),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
