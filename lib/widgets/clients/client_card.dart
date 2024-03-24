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
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            image: client.logoImgUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(client.logoImgUrl),
                    fit: BoxFit.cover,
                  )
                : null,
            color: Colors.grey.shade200,
          ),
          child: client.logoImgUrl.isEmpty
              ? const Icon(Icons.business, color: Colors.white)
              : null,
        ),
        title: Text(client.name),
        subtitle: Text(client.email),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.grey),
          onPressed: () {
            // TODO: Implement edit client functionality
          },
        ),
      ),
    );
  }
}
