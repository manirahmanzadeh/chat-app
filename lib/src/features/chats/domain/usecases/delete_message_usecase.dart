import 'package:chatapp/src/core/usecases/usecase.dart';
import 'package:chatapp/src/features/chats/domain/repository/chat_repository.dart';

class DeleteMessageUseCase implements UseCase<void, Map<String, dynamic>> {
  final ChatRepository _chatRepository;

  const DeleteMessageUseCase(this._chatRepository);

  @override
  Future<void> call({Map<String, dynamic>? params}) async {
    if (params != null) {
      return await _chatRepository.deleteMessage(params['chatId'], params['messageId']);
    }
    throw Exception('Data is empty!');
  }
}
