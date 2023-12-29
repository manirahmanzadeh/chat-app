import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required String messageId,
    required String senderUid,
    required String text,
    required DateTime timestamp,
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
      timestamp: DateTime.parse(data['timestamp']),
      edited: data['edited'] ?? false,
    );
  }
}
