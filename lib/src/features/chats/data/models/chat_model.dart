import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';

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
}
