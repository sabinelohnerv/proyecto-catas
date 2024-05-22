import 'package:catas_univalle/widgets/login/animations.dart';
import 'package:flutter/material.dart';


class StampContainer extends StatelessWidget {
  final String status;

  const StampContainer({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/images/pending-stamp.png';

    switch (status) {
      case "aprobado":
        imagePath = 'assets/images/accepted-stamp.png';

        break;
      case "rechazado":
        imagePath = 'assets/images/rejected-stamp.png';

        break;
      default:
        imagePath = 'assets/images/pending-stamp.png';
    }

    return Container(
      height: 230,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(10),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ESTADO DE APLICACIÓN',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary),
          ),
          const Divider(),
          FadeInAnimation(
            delay: 400,
            child: Image.asset(
              imagePath,
              width: 135,
              height: 135,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
