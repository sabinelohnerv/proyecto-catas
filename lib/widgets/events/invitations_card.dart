import 'package:flutter/material.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/functions/util.dart';

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
                color: event.imageUrl.isNotEmpty ? Colors.transparent : Colors.grey.shade200,
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
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      event.location,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$formattedDate, ${event.start} - ${event.end}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      state,  // Mostrar estado
                      style: TextStyle(fontSize: 14, color: stateColor, fontWeight: FontWeight.bold),
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
