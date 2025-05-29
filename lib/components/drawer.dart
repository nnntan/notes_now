import 'package:flutter/material.dart';
import 'package:notes_now/components/drawer_tile.dart';
import 'package:notes_now/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(children: [
        // Header
        SizedBox(
          height: 280.0,
          child: Center(
            child: Image.asset(
              'lib/images/images1.png',
              height: 120.0,
              width: 100.0,
            ),
          ),
        ),

        // notes tile
        DrawerTile(
          title: "Home",
          leading: const Icon(Icons.home),
          onTap: () => Navigator.pop(context),
        ),

        //setting tile
        DrawerTile(
            title: "Settings",
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            }),
      ]),
    );
  }
}
