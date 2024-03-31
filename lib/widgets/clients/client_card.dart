import 'package:catas_univalle/views/edit_client_view.dart';
import 'package:flutter/material.dart';
import 'package:catas_univalle/models/client.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({
    super.key,
    required this.client,
    required this.onDelete,
  });

  final Client client;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(client.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirmar eliminación"),
              content: Text(
                  "¿Estás seguro de querer eliminar al cliente: ${client.name.toUpperCase()}?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Eliminar"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancelar"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        onDelete();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
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
                color: client.logoImgUrl.isNotEmpty
                    ? Colors.transparent
                    : Colors.white,
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
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditClientView(client: client,),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
