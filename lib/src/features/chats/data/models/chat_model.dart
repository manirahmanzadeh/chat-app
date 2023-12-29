import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required String chatId,
    required List<String> participants,
    required List<String> displayNames,
    required List<String> imageUrls,
  }) : super(
          chatId: chatId,
          participants: participants,
          displayNames: displayNames,
          imageUrls: imageUrls,
        );

  factory ChatModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatModel(
      chatId: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      displayNames: List<String>.from(data['displayNames'] ?? []),
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
    );
  }
}
