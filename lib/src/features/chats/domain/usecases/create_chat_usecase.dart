import 'package:chatapp/src/core/usecases/usecase.dart';
import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';
import 'package:chatapp/src/features/chats/domain/repository/chats_repository.dart';

class CreateChatUseCase implements UseCase<ChatEntity, UserProfileEntity> {
  final ChatsRepository _chatsRepository;

  const CreateChatUseCase(this._chatsRepository);

  @override
  Future<ChatEntity> call({UserProfileEntity? params}) async {
    if (params != null) {
      return await _chatsRepository.createChat(params);
    }
    throw Exception('Other user is empty!');
  }
}
