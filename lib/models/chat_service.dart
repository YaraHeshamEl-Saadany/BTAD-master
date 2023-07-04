import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> sendMessage({
    required String senderEmail,
    required String receiverEmail,
    required String message,
  }) async {
    final chatCollection = _firestore.collection('chats');

    // Check if a chat document already exists for this sender-receiver pair
    final chatQuery = await chatCollection
        .where('senderEmail', isEqualTo: senderEmail)
        .where('receiverEmail', isEqualTo: receiverEmail)
        .limit(1)
        .get();

    if (chatQuery.docs.isNotEmpty) {
      // Chat document already exists, update it with the new message
      final chatDoc = chatQuery.docs.first;
      chatDoc.reference.update({
        'senderMessages': FieldValue.arrayUnion([message]),
        'senderTimestamps': FieldValue.arrayUnion([DateTime.now()]),
      });
    } else {
      // Chat document doesn't exist, create a new one
      chatCollection.add({
        'senderEmail': senderEmail,
        'receiverEmail': receiverEmail,
        'senderMessages': [message],
        'senderTimestamps': [DateTime.now()],
        'receiverMessages': [],
        'receiverTimestamps': [],
      });
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatsForUser(
    String email,
  ) {
    final chatCollection = _firestore.collection('chats');

    return chatCollection
        .where('senderEmail', isEqualTo: email)
        .orderBy('senderTimestamps', descending: true)
        .snapshots();
  }
}
