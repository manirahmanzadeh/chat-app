import 'package:chatapp/src/core/usecases/usecase.dart';
import 'package:chatapp/src/features/chats/domain/repository/chat_repository.dart';

class SendMessageUseCase implements UseCase<void, Map<String, dynamic>> {
  final ChatRepository _chatRepository;

  const SendMessageUseCase(this._chatRepository);

  @override
  Future<void> call({Map<String, dynamic>? params}) async {
    if (params != null) {
      return _chatRepository.createMessage(
        params['chatId'],
        params['senderUid'],
        params['onDone'],
        params['text'],
        params['file'],
        params['fileType'],
        params['onUploadProgress'],
      );
    }
    throw Exception('Data is empty!');
  }
}
