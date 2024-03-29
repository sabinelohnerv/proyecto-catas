import 'package:flutter/material.dart';

class EventImage extends StatelessWidget {
  final String imageUrl;

  const EventImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(25.0),
        bottomRight: Radius.circular(25.0),
      ),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey,
          height: 275,
          width: double.infinity,
          child: const Icon(Icons.error, color: Colors.red),
        ),
      ),
    );
  }
}
