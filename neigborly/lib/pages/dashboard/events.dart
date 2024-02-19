import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        backgroundColor: Color.fromARGB(255, 104, 220, 78),
      ),
      body: Center(
        child: Text(
          'Events will be displayed here!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
