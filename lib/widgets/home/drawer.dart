import 'package:flutter/material.dart';
import '../../views/profile_view.dart';

class CustomDrawer extends StatelessWidget {
  final String fullName;
  final String email;
  final String imageUrl;
  final VoidCallback onSignOut;

  const CustomDrawer({
    super.key,
    required this.fullName,
    required this.email,
    required this.imageUrl,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          buildDrawerHeader(context),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfileView()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Contact'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Information'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }

  Widget buildDrawerHeader(BuildContext context) {
    return Container(
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
