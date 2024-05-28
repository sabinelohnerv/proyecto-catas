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
    return LayoutBuilder(
      builder: (context, constraints) {
        double responsiveWidth = width;
        double responsiveHeight = height;
        double responsiveFontSize = fontSize;

        if (constraints.maxWidth < 600) {
          responsiveWidth = width * 0.8;
          responsiveHeight = height * 0.8;
          responsiveFontSize = fontSize * 0.8;
        } else if (constraints.maxWidth < 1200) {
          responsiveWidth = width * 1.0;
          responsiveHeight = height * 1.0;
          responsiveFontSize = fontSize * 1.0;
        } else {
          responsiveWidth = width * 1.2;
          responsiveHeight = height * 1.2;
          responsiveFontSize = fontSize * 1.2;
        }

        return InkWell(
          onTap: isClickable ? onTap ?? () => _handleTap(context) : null,
          child: Card(
            child: SizedBox(
              width: responsiveWidth,
              height: responsiveHeight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/$img.png',
                      width: responsiveWidth * 0.5,
                      height: responsiveHeight * 0.5,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        fontSize: responsiveFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
