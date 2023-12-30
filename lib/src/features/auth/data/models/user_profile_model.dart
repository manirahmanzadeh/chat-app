import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required String uid,
    required String email,
    String? displayName,
    String? photoURL,
    String? bio,
  }) : super(
          uid: uid,
          email: email,
          bio: bio,
          displayName: displayName,
          photoURL: photoURL,
        );

  factory UserProfileModel.fromEntity(UserProfileEntity userProfileEntity) => UserProfileModel(
        uid: userProfileEntity.uid,
        email: userProfileEntity.email ?? '',
        photoURL: userProfileEntity.photoURL ?? '',
        displayName: userProfileEntity.displayName ?? '',
        bio: userProfileEntity.bio ?? '',
      );

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        uid: json['uid'],
        email: json['email'] ?? '',
        photoURL: json['photoURL'] ?? '',
        displayName: json['displayName'] ?? '',
        bio: json['bio'] ?? '',
      );

  factory UserProfileModel.fromDocumentSnapshot(DocumentSnapshot<Object?> snapshot) => UserProfileModel(
        uid: snapshot['uid'],
        email: snapshot['email'] ?? '',
        photoURL: snapshot['photoURL'] ?? '',
        displayName: snapshot['displayName'] ?? '',
        bio: snapshot['bio'] ?? '',
      );

  factory UserProfileModel.fromUser(User user) => UserProfileModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        photoURL: user.photoURL ?? '',
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'photoURL': photoURL,
        'displayName': displayName,
        'bio': bio,
      };
}
