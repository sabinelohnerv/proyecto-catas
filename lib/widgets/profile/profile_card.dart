import 'package:flutter/material.dart';

class SimpleSectionCard extends StatelessWidget {
  final String img;
  final String title;
  final String subtitle;
  final Widget? destinationScreen;
  final bool isClickable;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final double fontSize;

  const SimpleSectionCard({
    super.key,
    required this.img,
    required this.title,
    required this.subtitle,
    this.destinationScreen,
    this.isClickable = true,
    this.onTap,
    this.width = 150,
    this.height = 150,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isClickable ? onTap ?? () => _handleTap(context) : null,
      child: Container(
        width: width,
        height: height,
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
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: fontSize,
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
