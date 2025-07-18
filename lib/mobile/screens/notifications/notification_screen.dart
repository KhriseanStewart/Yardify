import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  String title;
  String body;
  NotificationScreen({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications"), centerTitle: true),
      body: Column(children: [
          
        ],
      ),
    );
  }
}
