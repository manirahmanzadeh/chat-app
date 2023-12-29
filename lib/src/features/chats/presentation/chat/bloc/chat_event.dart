import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class LoadChatEvent implements ChatEvent {
  final ChatEntity chat;

  const LoadChatEvent(this.chat);
}

class SendMessageChatEvent implements ChatEvent {
  final String text;

  const SendMessageChatEvent(this.text);
}
