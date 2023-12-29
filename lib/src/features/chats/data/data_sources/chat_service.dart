import 'package:chatapp/src/features/chats/data/models/message_model.dart';
import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<MessageEntity>> getChatMessages(String chatId) {
    return _firebaseFirestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return MessageModel.fromMap(data, doc.id);
      }).toList();
    });
  }

  Future<MessageEntity> createMessage(String chatId, String senderUid, String text) async {
    DocumentReference messageRef = await _firebaseFirestore.collection('chats').doc(chatId).collection('messages').add({
      'senderUid': senderUid,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    }).onError((error, stackTrace) => throw (Exception(error)));

    DocumentSnapshot messageSnapshot = await messageRef.get().onError((error, stackTrace) => throw (Exception(error)));
    Map<String, dynamic> data = messageSnapshot.data() as Map<String, dynamic>;

    return MessageModel.fromMap(data, messageSnapshot.id);
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    return _firebaseFirestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete()
        .onError((error, stackTrace) => throw (Exception(error)));
  }

  Future<void> editMessage(String chatId, String messageId, String newText) async {
    return _firebaseFirestore.collection('chats').doc(chatId).collection('messages').doc(messageId).update({
      'text': newText,
      'edited': true, // Optionally, you can add a flag for edited messages
    }).onError((error, stackTrace) => throw (Exception(error)));
  }
}
