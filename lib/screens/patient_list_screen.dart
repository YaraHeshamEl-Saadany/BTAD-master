import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/chat_service.dart';
import '../models/user.dart';
import 'chat_doctor_screen.dart';

class PatientListScreen extends StatelessWidget {
  final UserModel user;

  const PatientListScreen({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient List'),
      ),
      body: _buildPatientList(context),
    );
  }

  Widget _buildPatientList(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ChatService.getChatsForUser(user.email),
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
          itemCount: chatDocs.length,
          itemBuilder: (context, index) {
            final chatDoc = chatDocs[index];
            final chatData = chatDoc.data();

            return Card(
              child: ListTile(
                title: Text(chatData['senderEmail']),
                onTap: () {
                  _openChatScreen(context, chatData);
                },
              ),
            );
          },
        );
      },
    );
  }

  void _openChatScreen(BuildContext context, Map<String, dynamic> chatData) {
    final receiverEmail = chatData['senderEmail'];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChatDoctorScreen(user: user, receiverEmail: receiverEmail),
      ),
    );
  }
}
