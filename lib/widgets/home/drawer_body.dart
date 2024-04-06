import 'package:flutter/material.dart';

class DrawerBodyWidget extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onContactTap;
  final VoidCallback onInformationTap;
  final VoidCallback onSignOut;

  const DrawerBodyWidget({
    super.key,
    required this.onProfileTap,
    required this.onContactTap,
    required this.onInformationTap,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text('Perfil'),
            onTap: onProfileTap,
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Información'),
            onTap: onInformationTap,
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Contacto'),
            onTap: onContactTap,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}
