import 'dart:io';

import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Stream<List<MessageEntity>> getChatMessages(String chatId);

  Future<void> createMessage(
    String chatId,
    String senderUid,
    Function() onDone,
    String text,
    File? file,
    String? fileType,
    Function(double)? onUploadProgress,
  );

  Future<void> deleteMessage(String chatId, String messageId);

  Future<void> editMessage(String chatId, String messageId, String newText);
}
