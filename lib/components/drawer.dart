import 'package:flutter/material.dart';
import 'package:note_app_flutter2/components/drawer_tile.dart';
import 'package:note_app_flutter2/pages/settings_page.dart';

class Mydrawer extends StatelessWidget {
  const Mydrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // header
          const DrawerHeader(
            child: Icon(Icons.notes),
          ),

          const SizedBox(height: 10),

          // notes tile
          DrawerTile(
            title: "Notes",
            leading: const Icon(Icons.home),
            onTap: () => Navigator.pop(context),
          ),

          // settings tile
          DrawerTile(
            title: "Settings",
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
