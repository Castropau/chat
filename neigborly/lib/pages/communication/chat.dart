import 'package:flutter/material.dart';
import 'package:neigborly/api/database_service.dart';
import 'package:neigborly/pages/communication/recent_convo.dart';

class ConvoPage extends StatefulWidget {
  final Map userdata;
  final int ticket_number;

  const ConvoPage({Key? key, required this.userdata, required this.ticket_number}) : super(key: key);

  @override
  _ConvoPageState createState() => _ConvoPageState();
}

class _ConvoPageState extends State<ConvoPage> {
  final TextEditingController _messageController = TextEditingController();
  List<dynamic> _messages = [];
  int _threadId = 1;

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      List<dynamic> messages = await DatabaseService().getMessagesByThreadId(widget.ticket_number);
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 104, 220, 78),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecentConvoPage(userdata: widget.userdata)),
            );
          },
        ),
        title: Text('Chat Message - ${widget.userdata["first_name"]}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                Icon(Icons.support_agent_outlined), // Add your icon here
                SizedBox(width: 8), // Add some space between the icon and the text
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageTile(
                  message: _messages[index],
                  isCurrentUser:false
                );
              },
            ),
          ),
          InputRow(
            threadId: _threadId,
            messageController: _messageController,
            onSendPressed: () async {
              String message = _messageController.text.trim();
              if (message.isNotEmpty) {
                await _sendMessage(widget.userdata["first_name"], 'images/logo.jpg', _threadId, message);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String user, String avatarPath, int threadId, String message) async {
    _messageController.clear();

    try {
      await DatabaseService().insertMessage(message, threadId);

      await fetchMessages();
    } catch (e) {
      print('Error inserting message: $e');
    }
  }
}

class MessageTile extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isCurrentUser;

  const MessageTile({
    Key? key,
    required this.message,
    required this.isCurrentUser,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
 return ChatMessageWidget(
                  message: message['message'],
                  isOwner: message['isStaff'],
                );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4.0),
  //     child: Row(
  //       mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
  //       children: [
  //         // if (!isCurrentUser)
  //         //   const Padding(
  //         //     padding: EdgeInsets.only(right: 8.0),
  //         //     child: CircleAvatar(
  //         //       backgroundColor: Colors.grey,
  //         //       child: Icon(Icons.person, color: Colors.white),
  //         //     ),
  //         //   ),
  //         Flexible(
  //           child: Column(
  //             crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  //             children: [
  //               ChatMessageWidget(
  //                 message: message['message'],
  //                 isOwner: message['isStaff'],
  //               )
  //               // if (message['isStaff'] == 1)
  //               //   Container(
  //               //     margin: const EdgeInsets.only(bottom: 4.0),
  //               //     padding: const EdgeInsets.all(8.0),
  //               //     decoration: BoxDecoration(
  //               //       color: Colors.grey.withOpacity(0.1),
  //               //       borderRadius: BorderRadius.circular(8.0),
  //               //     ),
  //               //     child: Text(
  //               //       '${message['reply_content']}',
  //               //       softWrap: true,
  //               //       style: const TextStyle(color: Colors.black87),
  //               //     ),
  //               //   ),
  //               // Row(
  //               //   mainAxisAlignment: isCurrentUser
  //               //       ? MainAxisAlignment.end // Align to end if it's the current user's message
  //               //       : MainAxisAlignment.start, // Align to start otherwise
  //               //   children: [
  //               //     if (!isCurrentUser) Spacer(), // Add Spacer before the message content for alignment
  //               //     Container(
  //               //       constraints: BoxConstraints(
  //               //         maxWidth: MediaQuery.of(context).size.width * 0.7, // Adjust maxWidth as needed
  //               //       ),
  //               //       padding: const EdgeInsets.all(8.0),
  //               //       margin: const EdgeInsets.symmetric(horizontal: 8.0),
  //               //       decoration: BoxDecoration(
  //               //         color: isCurrentUser ? Colors.blue : Colors.grey.withOpacity(0.2),
  //               //         borderRadius: BorderRadius.only(
  //               //           topLeft: Radius.circular(18.0),
  //               //           topRight: Radius.circular(18.0),
  //               //           bottomLeft: isCurrentUser ? Radius.circular(18.0) : Radius.circular(0),
  //               //           bottomRight: isCurrentUser ? Radius.circular(0) : Radius.circular(18.0),
  //               //         ),
  //               //       ),
  //               //       child: Text(
  //               //         message['message_content'],
  //               //         softWrap: true,
  //               //         style: TextStyle(
  //               //           color: isCurrentUser ? Colors.white : Colors.black87,
  //               //         ),
  //               //       ),
  //               //     ),
  //               //     if (isCurrentUser) Spacer(), // Add Spacer after the message content for alignment
  //               //   ],
  //               // ),
  //             ],
  //           ),
  //         ),
  //         if (isCurrentUser)
  //           Padding(
  //             padding: const EdgeInsets.only(left: 8.0),
  //             child: CircleAvatar(
  //               backgroundColor: Colors.grey,
  //               child: Icon(Icons.person, color: Colors.white),
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }
}

class InputRow extends StatelessWidget {
  final TextEditingController messageController;
  final int threadId;
  final VoidCallback onSendPressed;

  InputRow({required this.threadId, required this.messageController, required this.onSendPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: onSendPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final String message;
  final bool isOwner;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOwner ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 5.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isOwner ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message,
          textAlign: TextAlign.right,
          style: TextStyle(color: isOwner ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}