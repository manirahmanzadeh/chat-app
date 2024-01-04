import 'package:chatapp/src/core/usecases/usecase.dart';
import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';
import 'package:chatapp/src/features/chats/domain/repository/chat_repository.dart';

class GetMessagesUseCase implements SyncUseCase<Stream<List<MessageEntity>>, String> {
  final ChatRepository _chatRepository;

  GetMessagesUseCase(this._chatRepository);

  @override
  Stream<List<MessageEntity>> call({String? params}) {
    if (params != null) {
      return _chatRepository.getChatMessages(params);
    }
    throw Exception('Chat id is empty!');
  }
}
