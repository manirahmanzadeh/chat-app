import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';

abstract class ContactEvent {
  const ContactEvent();
}

class GetContactsContactEvent extends ContactEvent {
  const GetContactsContactEvent();
}

class CreateChatContactsEvent extends ContactEvent {
  final List<UserProfileEntity> loadedProfiles;
  final UserProfileEntity targetUser;

  const CreateChatContactsEvent(
    this.targetUser,
    this.loadedProfiles,
  );
}
