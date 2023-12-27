import 'package:chatapp/src/core/usecases/usecase.dart';
import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';
import 'package:chatapp/src/features/chats/domain/repository/chats_repository.dart';

class GetChatsUseCase implements SyncUseCase<Stream<List<ChatEntity>>, void> {
  final ChatsRepository _chatsRepository;

  GetChatsUseCase(this._chatsRepository);

  @override
  Stream<List<ChatEntity>> call({void params}) {
    return _chatsRepository.getChats();
  }
}
