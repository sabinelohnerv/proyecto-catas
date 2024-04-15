import 'package:catas_univalle/views/admin_profile_view.dart';
import 'package:catas_univalle/views/profile_view.dart';
import 'package:catas_univalle/widgets/home/drawer_body.dart';
import 'package:catas_univalle/widgets/home/drawer_header.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String fullName;
  final String email;
  final String imageUrl;
  final bool role;
  final VoidCallback onSignOut;

  const CustomDrawer({
    super.key,
    required this.fullName,
    required this.email,
    required this.imageUrl,
    required this.onSignOut,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeaderWidget(
            fullName: fullName,
            email: email,
            imageUrl: imageUrl,
          ),
          DrawerBodyWidget(
            onProfileTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      role ? const AdminProfileView() : const ProfileView()),
            ),
            onContactTap: () {},
            onInformationTap: () {},
            onSignOut: onSignOut,
          ),
        ],
      ),
    );
  }
}
