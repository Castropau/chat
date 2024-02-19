import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        backgroundColor:
            Color.fromARGB(255, 104, 220, 78), 
      ),
      body: Center(
        child: Text('Tasks Page Content'),
      ),
    );
  }
}
