import 'package:chatapp/src/core/usecases/usecase.dart';
import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:chatapp/src/features/chats/domain/repository/chats_repository.dart';

class GetContactsUseCase implements UseCase<List<UserProfileEntity>, void> {
  final ChatsRepository _chatsRepository;

  const GetContactsUseCase(this._chatsRepository);

  @override
  Future<List<UserProfileEntity>> call({void params}) {
    return _chatsRepository.getContacts();
  }
}
