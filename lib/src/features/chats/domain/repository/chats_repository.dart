import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';

abstract class ChatsRepository {
  Stream<List<ChatEntity>> getChats();

  Future<void> createChat(UserProfileEntity otherUser);

  Future<List<UserProfileEntity>> getContacts();
}
