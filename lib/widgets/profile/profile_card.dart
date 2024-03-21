import 'package:flutter/material.dart';

class SimpleSectionCard extends StatelessWidget {
  final String img;
  final String title;
  final String subtitle;
  final Widget? destinationScreen;
  final bool isClickable;

  const SimpleSectionCard({
    Key? key,
    required this.img,
    required this.title,
    required this.subtitle,
    this.destinationScreen,
    this.isClickable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isClickable ? () => _handleTap(context) : null,
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/$img.png',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    if (destinationScreen != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => destinationScreen!),
      );
    }
  }
}
