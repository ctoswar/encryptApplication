import 'package:flutter/material.dart';
import 'package:flutterencryption/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  const MyDrawer({
    super.key,
    required this.onProfileTap,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 64,
            ),
          ),
          // home list
          MyListTile(
            icon: Icons.home,
            text: "Home",
            onTap: () => Navigator.pop(context),
          ),

          // profile
          MyListTile(
            icon: Icons.person,
            text: "profile",
            onTap: onProfileTap,
          ),

          //logout
          MyListTile(
            icon: Icons.logout,
            text: "Logout",
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}
