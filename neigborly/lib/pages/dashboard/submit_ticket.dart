import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neigborly/api/database_service.dart';

class TicketRequestPage extends StatefulWidget {
  final String userEmail;

  TicketRequestPage({required this.userEmail});

  @override
  _TicketRequestPageState createState() => _TicketRequestPageState();
}

class _TicketRequestPageState extends State<TicketRequestPage> {
  Map<String, dynamic>? _selectedMessageType;
  List<Map<String, dynamic>> _messageTypes = [];
  late int _memId;

  @override
  void initState() {
    super.initState();
    _fetchMessageTypes();
    _fetchMemberId();
  }

  Future<void> _fetchMessageTypes() async {
    List<Map<String, dynamic>> messageTypes =
        await DatabaseService().getMessageTypes();
    setState(() {
      _messageTypes = messageTypes;
    });
  }

  Future<void> _fetchMemberId() async {
    
    String email = widget.userEmail;
    int memberId = await DatabaseService().fetchUserId(email); 
    setState(() {
      _memId = memberId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Ticket for Concern'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<Map<String, dynamic>>(
              value: _selectedMessageType,
              items: _messageTypes.map((messageType) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: messageType,
                  child: Text(messageType['message_type'].toString()),
                );
              }).toList(),
              onChanged: (Map<String, dynamic>? value) {
                setState(() {
                  _selectedMessageType = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Message Type',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _submitTicketRequest();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitTicketRequest() async {
  if (_selectedMessageType == null) {
    print('Please select a message type');
    return;
  }

  if (_memId == null) {
    print('Error: Member ID is not fetched yet.');
    return;
  }

  int ticketNumber = _generateTicketNumber();
  int messageTypeId = _selectedMessageType!['id'];
  int threadId = 1;
  bool isActive = true;
  try {
    await DatabaseService().submitThreadTicket(_memId, messageTypeId,
        ticketNumber, threadId,
        isActive: isActive, threadTitle: "sample thread");
    print('Ticket request submitted successfully');
  } catch (e) {
    print('Failed to submit ticket request: $e');
  }
}

  int _generateTicketNumber() {
    Random random = Random();
    return 100000 + random.nextInt(900000);
  }
}
