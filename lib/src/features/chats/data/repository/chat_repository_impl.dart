import 'package:chatapp/src/features/chats/data/data_sources/chat_service.dart';
import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';
import 'package:chatapp/src/features/chats/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatService _chatService;

  const ChatRepositoryImpl(this._chatService);

  @override
  Future<MessageEntity> createMessage(String chatId, String senderUid, String text) {
    return _chatService.createMessage(chatId, senderUid, text);
  }

  @override
  Future<void> deleteMessage(String chatId, String messageId) {
    return _chatService.deleteMessage(chatId, messageId);
  }

  @override
  Future<void> editMessage(String chatId, String messageId, String newText) {
    return _chatService.editMessage(chatId, messageId, newText);
  }

  @override
  Stream<List<MessageEntity>> getChatMessages(String chatId) {
    return _chatService.getChatMessages(chatId);
  }
}
