import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required String messageId,
    required String senderUid,
    required String text,
    required Timestamp timestamp,
    bool edited = false,
  }) : super(
          senderUid: senderUid,
          text: text,
          timestamp: timestamp,
          messageId: messageId,
          edited: edited,
        );

  factory MessageModel.fromMap(Map<String, dynamic> data, String id) {
    return MessageModel(
      messageId: id,
      senderUid: data['senderUid'],
      text: data['text'],
      timestamp: data['timestamp'] ?? Timestamp.now(),
      edited: data['edited'] ?? false,
    );
  }
}
