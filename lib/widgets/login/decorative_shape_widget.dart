import 'package:flutter/widgets.dart';

class HeaderShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color.fromARGB(255, 232, 137, 158);
    Path path = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(
        size.width / 2,
        size.height,
        size.width / 1,
        size.height * 0.8,
      )
      ..quadraticBezierTo(
        3 * size.width / 4,
        size.height * 0.6,
        size.width,
        size.height * 0.8,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
