import 'package:flutter/material.dart';

class DrawerHeaderWidget extends StatelessWidget {
  final String fullName;
  final String email;
  final String imageUrl;

  const DrawerHeaderWidget({
    super.key,
    required this.fullName,
    required this.email,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(
          top: 30 + MediaQuery.of(context).padding.top, bottom: 30),
      child: Column(
        children: [
          CircleAvatar(
            radius: 52,
            backgroundColor: Theme.of(context).primaryColorLight,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(height: 10),
          Text(
            fullName,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            email,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
