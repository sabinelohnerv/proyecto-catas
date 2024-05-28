import 'package:flutter/material.dart';

class SmallCard extends StatelessWidget {
  final String img;
  final String title;
  final Widget? destinationScreen;
  final bool isClickable;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final double fontSize;

  const SmallCard({
    super.key,
    required this.img,
    required this.title,
    this.destinationScreen,
    this.isClickable = true,
    this.onTap,
    this.width = 150,
    this.height = 150,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isClickable ? onTap ?? () => _handleTap(context) : null,
      child: Card(
        child: SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/$img.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 12),
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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