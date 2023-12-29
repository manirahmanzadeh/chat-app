import 'package:chatapp/src/core/usecases/usecase.dart';
import 'package:chatapp/src/features/chats/domain/repository/chat_repository.dart';

class EditMessageUseCase implements UseCase<void, Map<String, dynamic>> {
  final ChatRepository _chatRepository;

  const EditMessageUseCase(this._chatRepository);

  @override
  Future<void> call({Map<String, dynamic>? params}) async {
    if (params != null) {
      return await _chatRepository.editMessage(
        params['chatId'],
        params['messageId'],
        params['newText'],
      );
    }
    throw Exception('Data is empty!');
  }
}
