import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color.fromARGB(255, 104, 220, 78),
      ),
      body: Center(
        child: Text('Settings Page Content'),
      ),
    );
  }
}
