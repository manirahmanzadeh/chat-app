import 'package:chatapp/src/features/auth/data/data_sources/firebase_auth_service.dart';
import 'package:chatapp/src/features/chats/data/data_sources/chats_service.dart';
import 'package:chatapp/src/features/chats/data/models/chat_model.dart';
import 'package:chatapp/src/features/chats/domain/repository/chats_repository.dart';

class ChatsRepositoryImpl implements ChatsRepository {
  final ChatsService _chatsService;
  final FirebaseAuthService _firebaseAuthService;

  const ChatsRepositoryImpl(this._chatsService, this._firebaseAuthService);

  @override
  Future<void> createChat() {
    // TODO: implement createChat
    throw UnimplementedError();
  }

  @override
  Stream<List<ChatModel>> getChats() {
    final user = _firebaseAuthService.currentUser;
    if (user != null) {
      return _chatsService.getChats(user);
    }
    throw Exception('User does not exist!');
  }
}
