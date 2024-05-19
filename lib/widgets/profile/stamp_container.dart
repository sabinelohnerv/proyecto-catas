import 'package:catas_univalle/widgets/login/animations.dart';
import 'package:flutter/material.dart';

import 'pointed_border.dart';

class StampContainer extends StatelessWidget {
  final String status;

  const StampContainer({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    String certificationStatus;
    Color statusColor;

    switch (status) {
      case "aprobado":
        certificationStatus = "Aprobado";
        statusColor = Colors.green;
        break;
      case "rechazado":
        certificationStatus = "Rechazado";
        statusColor = Colors.red;

        break;
      default:
        certificationStatus = "Pendiente";
        statusColor = Colors.amber;
    }

    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ESTADO DE APLICACIÓN',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FadeInAnimation(
              delay: 400,
              child: CustomPaint(
                size: const Size(double.infinity, 50),
                painter: DottedBorderPainter(color: statusColor),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                      color: statusColor,
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Text(
                            certificationStatus.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
