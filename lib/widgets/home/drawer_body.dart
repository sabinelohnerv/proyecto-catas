import 'package:flutter/material.dart';

class DrawerBodyWidget extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onContactTap;
  final VoidCallback onInformationTap;
  final bool isSuperAdmin;
  final VoidCallback onAdminTap;
  final VoidCallback onSignOut;

  const DrawerBodyWidget({
    super.key,
    required this.onProfileTap,
    required this.onContactTap,
    required this.onInformationTap,
    required this.isSuperAdmin,
    required this.onAdminTap,
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
          if (isSuperAdmin)
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Administradores'),
              onTap: onAdminTap,
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
