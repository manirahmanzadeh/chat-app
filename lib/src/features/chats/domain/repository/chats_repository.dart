import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';

abstract class ChatsRepository {
  Stream<List<ChatEntity>> getChats();

  Future<void> createChat();
}
