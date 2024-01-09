import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('Home'),
            onTap: () {
              // Handle the Home item tap
              // ...
            },
          ),
          ExpansionTile(
            title: Text('Nested Menu'),
            children: [
              ListTile(
                title: Text('Nested Item 1'),
                onTap: () {
                  // Handle the Nested Item 1 tap
                  // ...
                },
              ),
              ListTile(
                title: Text('Nested Item 2'),
                onTap: () {
                  // Handle the Nested Item 2 tap
                  // ...
                },
              ),
            ],
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              // Handle the Settings item tap
              // ...
            },
          ),
        ],
      ),
    );
  }
}
