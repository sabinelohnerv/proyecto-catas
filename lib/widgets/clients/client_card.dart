import 'package:catas_univalle/models/client.dart';
import 'package:flutter/material.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({
    super.key,
    required this.client,
  });

  final Client client;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: client.logoImgUrl.isNotEmpty
              ? NetworkImage(client.logoImgUrl)
              : null,
          child: client.logoImgUrl.isEmpty ? const Icon(Icons.business) : null,
        ),
        title: Text(client.name),
        subtitle: Text(client.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                // todo: edit client
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // todo: delete client
              },
            ),
          ],
        ),
      ),
    );
  }
}
