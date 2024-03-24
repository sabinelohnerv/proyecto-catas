import 'package:flutter/material.dart';
import 'package:catas_univalle/models/client.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({
    super.key,
    required this.client,
  });

  final Client client;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Implement onTap functionality if needed
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.20,
              height: MediaQuery.of(context).size.width * 0.20,
              decoration: BoxDecoration(
                image: client.logoImgUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(client.logoImgUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: client.logoImgUrl.isNotEmpty ? Colors.transparent : Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: client.logoImgUrl.isEmpty
                  ? const Icon(Icons.business, size: 40, color: Colors.white)
                  : null,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      client.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      client.email,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                // TODO: Implement edit client functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
