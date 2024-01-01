import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class LoadChatEvent implements ChatEvent {
  final ChatEntity chat;
  final UserProfileEntity userProfile;

  const LoadChatEvent(this.chat, this.userProfile);
}

class SendMessageChatEvent implements ChatEvent {
  final String text;

  const SendMessageChatEvent(this.text);
}

class DeleteMessageChatEvent implements ChatEvent {
  final String messageId;

  const DeleteMessageChatEvent(this.messageId);
}
