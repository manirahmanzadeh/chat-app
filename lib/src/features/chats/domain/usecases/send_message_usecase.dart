import 'package:chatapp/src/core/usecases/usecase.dart';
import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';
import 'package:chatapp/src/features/chats/domain/repository/chat_repository.dart';

class SendMessageUseCase implements UseCase<MessageEntity, Map<String, dynamic>> {
  final ChatRepository _chatRepository;

  const SendMessageUseCase(this._chatRepository);

  @override
  Future<MessageEntity> call({Map<String, dynamic>? params}) async {
    if (params != null) {
      return await _chatRepository.createMessage(
        params['chatId'],
        params['senderUid'],
        params['text'],
      );
    }
    throw Exception('Data is empty!');
  }
}
