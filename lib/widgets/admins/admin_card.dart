import 'package:catas_univalle/models/admin.dart';
import 'package:flutter/material.dart';

class AdminCard extends StatelessWidget {
  const AdminCard(
      {super.key, required this.admin, required this.isCurrentAdmin});

  final Admin admin;
  final bool isCurrentAdmin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: admin.profileImgUrl.isNotEmpty
              ? NetworkImage(admin.profileImgUrl)
              : null,
          child: admin.profileImgUrl.isEmpty
              ? const Icon(Icons.person_outline)
              : null,
        ),
        title: Row(
          children: [
            Text(
              admin.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(
              width: 5,
            ),
            if (admin.role == 'admin')
              const Text('(Tu cuenta)', style: TextStyle(color: Colors.grey, fontSize: 14),)
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(admin.email),
        ),
        trailing: isCurrentAdmin
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 20,
                ))
            : null,
      ),
    );
  }
}
