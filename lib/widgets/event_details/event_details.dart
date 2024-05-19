import 'package:flutter/material.dart';

class EventDetail extends StatelessWidget {
  final IconData? icon;
  final String text;
  final String? imageUrl;

  const EventDetail({
    super.key,
    this.icon,
    required this.text,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (imageUrl != null)
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl!),
              radius: 16,
            )
          else if (icon != null)
            CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
                child: Icon(icon, color: Theme.of(context).primaryColor)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
