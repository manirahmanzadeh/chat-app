import 'package:chatapp/src/features/auth/data/models/user_profile_model.dart';
import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileService {
  UserProfileEntity? _userProfile;

  UserProfileEntity? get currentProfile => _userProfile;

  Future<void> getOrCreateUserProfile(User user) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get().onError((error, stackTrace) => throw (Exception(error)));

    if (userSnapshot.exists) {
      _userProfile = UserProfileModel.fromDocumentSnapshot(userSnapshot);
    } else {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'bio': null,
      }).onError((error, stackTrace) => throw (Exception(error)));
      _userProfile = UserProfileModel.fromUser(user);
    }
  }

  void signOut() {
    _userProfile = null;
  }

  Future<void> updateUserProfile(User user, [String? bio]) async {
    if (_userProfile != null) {
      final userData = {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'bio': bio,
      };
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(userData)
          .onError((error, stackTrace) => throw (Exception(error)));
      _userProfile = UserProfileModel.fromJson(userData);
    }
  }
}
