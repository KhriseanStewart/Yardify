import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            children: <Widget>[
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Welcome USERNAME'),
              ),

              Divider(height: 1, thickness: 1),

              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Account Settings'),
                // selected: _selectedDestination == 0,
                // onTap: () => selectDestination(0),
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Loyalty & Rewards'),
                // selected: _selectedDestination == 1,
                // onTap: () => selectDestination(1),
              ),
              ListTile(
                leading: Icon(Icons.label),
                title: Text('Privacy & Security'),
                // selected: _selectedDestination == 2,
                // onTap: () => selectDestination(2),
              ),
              Divider(height: 1, thickness: 1),
              ListTile(
                leading: Icon(Icons.bookmark),
                title: Text('Preferences & Customizations'),
                // selected: _selectedDestination == 3,
                // onTap: () => selectDestination(3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
