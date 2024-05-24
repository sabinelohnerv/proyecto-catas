import 'package:catas_univalle/functions/util.dart';
import 'package:flutter/material.dart';
import 'package:catas_univalle/models/event.dart';

class AdminEventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const AdminEventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDateToWrittenDate(event.date);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.width * 0.25,
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
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 15, color: Colors.grey.shade600),
                        const SizedBox(width: 2),
                        Text(
                          event.location,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.calendar_month,
                            size: 15, color: Colors.grey.shade600),
                        const SizedBox(width: 2),
                        Text(
                          '$formattedDate, ${event.start} - ${event.end}',
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
