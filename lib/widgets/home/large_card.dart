import 'package:flutter/material.dart';

class LargeCard extends StatelessWidget {
  final String img;
  final String title;
  final bool isClickable;
  final VoidCallback? onTap;

  const LargeCard({
    super.key,
    required this.img,
    required this.title,
    this.isClickable = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isClickable ? onTap : null,
      child: Card(
        child: SizedBox(
          width: double.infinity,
          height: 170,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/$img.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 12),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
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
}
