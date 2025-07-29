import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:recipe_book_app/main.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context);
    final isDarkMode = appState?.isDarkMode ?? false;
    return Drawer(
      shape: ContinuousRectangleBorder(),

      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Text(
              'Recipe Book',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart_outlined),
            title: Text('Shopping List'),
            onTap: () => Navigator.pushNamed(context, '/shopping-list'),
          ),
          ListTile(
            leading: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            title: Text(isDarkMode ? 'Light Mode' : 'Dark Mode'),

            onTap: () {
              log("Changing theme to: ${isDarkMode ? 'Light' : 'Dark'}");
              appState?.toggleTheme();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
