import 'package:flutter/material.dart';
import 'package:neigborly/api/database_service.dart';
import 'package:neigborly/pages/dashboard/dashboard.dart';
import 'chat.dart';

class RecentConvoPage extends StatefulWidget {
  final Map userdata;

  const RecentConvoPage({Key? key, required this.userdata}) : super(key: key);

  @override
  _RecentConvoPageState createState() => _RecentConvoPageState();
}

class _RecentConvoPageState extends State<RecentConvoPage> {
  List<Map<String, dynamic>> chatMessages = [];

  @override
  void initState() {
    super.initState();
    _fetchChatMessages();
  }

Future<void> _fetchChatMessages() async {
  String email = widget.userdata['email'];

  DatabaseService databaseService = DatabaseService();
  
  int memId = await databaseService.fetchMemberId(email);
  
  List<Map<String, dynamic>> messages = await databaseService.fetchChatMessages(memId);
  
  setState(() {
    chatMessages = messages;
  });
}



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Recent Tickets'),
          backgroundColor: Color.fromARGB(255, 104, 220, 78),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard(userdata: widget.userdata)),
              );
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  final message = chatMessages[index];
                  return ListTile(
                   leading: Icon(
  Icons.confirmation_num_outlined, 
  color: Colors.grey, 
),

                    title: Text('(${message['ticket_number']}) ${message['message_type']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConvoPage(userdata: widget.userdata, ticket_number: int.parse( message['ticket_number']??0),),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
