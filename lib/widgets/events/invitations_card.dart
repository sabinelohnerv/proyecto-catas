import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/functions/util.dart';
import 'package:flutter/widgets.dart';

class InvitationsCard extends StatelessWidget {
  final Event event;
  final String state;
  final VoidCallback onTap;

  const InvitationsCard({
    super.key,
    required this.event,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDateToWrittenDate(event.date);
    Color stateColor = _getStateColor(state);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 10, 20, 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.20,
              height: MediaQuery.of(context).size.width * 0.20,
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
                        Flexible(
                          child: Text(
                            event.location,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.calendar_month,
                            size: 15, color: Colors.grey.shade600),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            formattedDate,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              width: MediaQuery.of(context).size.width * 0.26,
              height: MediaQuery.of(context).size.width * 0.07,
              decoration: BoxDecoration(
                color: stateColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  state.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStateColor(String state) {
    switch (state.toLowerCase()) {
      case 'aceptado':
        return Colors.green;
      case 'rechazado':
        return Colors.red;
      case 'pendiente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
