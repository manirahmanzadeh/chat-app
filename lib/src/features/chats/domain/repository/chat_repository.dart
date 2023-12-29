import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Stream<List<MessageEntity>> getChatMessages(String chatId);

  Future<MessageEntity> createMessage(String chatId, String senderUid, String text);

  Future<void> deleteMessage(String chatId, String messageId);

  Future<void> editMessage(String chatId, String messageId, String newText);
}
