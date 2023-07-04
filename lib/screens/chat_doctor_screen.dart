import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/chat_service.dart';
import '../models/user.dart';

class ChatDoctorScreen extends StatefulWidget {
  final UserModel user;
  final String receiverEmail;

  const ChatDoctorScreen(
      {Key? key, required this.user, required this.receiverEmail})
      : super(key: key);

  @override
  _ChatDoctorScreenState createState() => _ChatDoctorScreenState();
}

class _ChatDoctorScreenState extends State<ChatDoctorScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> _chatStream;

  @override
  void initState() {
    super.initState();
    _chatStream = ChatService.getChatsForUser(widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.receiverEmail}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _chatStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final chatDocs = snapshot.data?.docs ?? [];

                if (chatDocs.isEmpty) {
                  return Text('No chat messages found.');
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (context, index) {
                    final chatDoc = chatDocs[index];
                    final chatData = chatDoc.data();

                    return ListTile(
                      title: Text(chatData['senderEmail']),
                      subtitle: Text(chatData['senderMessages'].join('\n')),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Enter message'),
                  ),
                ),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      await ChatService.sendMessage(
        senderEmail: widget.user.email,
        receiverEmail: widget.receiverEmail,
        message: message,
      );
      _messageController.clear();
    }
  }
}
