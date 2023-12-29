import 'package:chatapp/src/features/auth/data/data_sources/firebase_auth_service.dart';
import 'package:chatapp/src/features/auth/data/data_sources/user_profile_service.dart';
import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:chatapp/src/features/chats/data/data_sources/chats_service.dart';
import 'package:chatapp/src/features/chats/data/models/chat_model.dart';
import 'package:chatapp/src/features/chats/domain/repository/chats_repository.dart';

class ChatsRepositoryImpl implements ChatsRepository {
  final ChatsService _chatsService;
  final FirebaseAuthService _firebaseAuthService;
  final UserProfileService _userProfileService;

  const ChatsRepositoryImpl(
    this._chatsService,
    this._firebaseAuthService,
    this._userProfileService,
  );

  @override
  Future<void> createChat(UserProfileEntity otherUser) {
    final user = _userProfileService.currentProfile;
    if (user != null) {
      return _chatsService.createChat(user, otherUser);
    }
    throw Exception('User does not exist!');
  }

  @override
  Stream<List<ChatModel>> getChats() {
    final user = _firebaseAuthService.currentUser;
    if (user != null) {
      return _chatsService.getChats(user);
    }
    throw Exception('User does not exist!');
  }

  @override
  Future<List<UserProfileEntity>> getContacts() {
    final user = _firebaseAuthService.currentUser;
    if (user != null) {
      return _chatsService.getContacts(user);
    }
    throw Exception('User does not exist!');
  }
}
