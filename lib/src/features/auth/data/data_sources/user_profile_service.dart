import 'package:chatapp/src/features/auth/data/models/user_profile_model.dart';
import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileService {
  UserProfileEntity? _userProfile;

  UserProfileEntity? get currentProfile => _userProfile;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> checkProfileExistenceAndFill(User user) async {
    DocumentSnapshot userSnapshot =
        await _firebaseFirestore.collection('users').doc(user.uid).get().onError((error, stackTrace) => throw (Exception(error)));

    if (userSnapshot.exists) {
      _userProfile = UserProfileModel.fromDocumentSnapshot(userSnapshot);
      return true;
    }
    return false;
  }

  Future<void> getOrCreateUserProfile(User user) async {
    DocumentSnapshot userSnapshot =
        await _firebaseFirestore.collection('users').doc(user.uid).get().onError((error, stackTrace) => throw (Exception(error)));

    if (userSnapshot.exists) {
      _userProfile = UserProfileModel.fromDocumentSnapshot(userSnapshot);
    } else {
      await _firebaseFirestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'phoneNumber': user.phoneNumber,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'bio': null,
      }).onError((error, stackTrace) => throw (Exception(error)));
      _userProfile = UserProfileModel.fromUser(user);
    }
  }

  Future<UserProfileEntity> getUserProfile(String uid) async {
    DocumentSnapshot userSnapshot =
        await _firebaseFirestore.collection('users').doc(uid).get().onError((error, stackTrace) => throw (Exception(error)));
    if (userSnapshot.exists) {
      return UserProfileModel.fromDocumentSnapshot(userSnapshot);
    } else {
      throw (Exception('User Profile Does not exists with uid: $uid'));
    }
  }

  void signOut() {
    _userProfile = null;
  }

  Future<void> updateUserProfile(User user, [String? bio]) async {
    if (_userProfile != null) {
      final userData = {
        'uid': user.uid,
        'phoneNumber': user.phoneNumber,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'bio': bio,
      };
      await _firebaseFirestore.collection('users').doc(user.uid).update(userData).onError((error, stackTrace) => throw (Exception(error)));
      _userProfile = UserProfileModel.fromJson(userData);
    }
  }
}
