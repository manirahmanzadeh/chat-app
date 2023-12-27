import 'package:chatapp/src/features/auth/data/models/user_profile_model.dart';
import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:chatapp/src/features/chats/data/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatsService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<ChatModel>> getChats(User user) {
    return _firebaseFirestore.collection('chats').where('participants', arrayContains: user.uid).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ChatModel(
          chatId: doc.id,
          participants: List<String>.from(data['participants'] ?? []),
          displayNames: List<String>.from(data['displayNames'] ?? []),
          imageUrls: List<String>.from(data['imageUrls'] ?? []),
        );
      }).toList();
    });
  }

  Stream<List<UserProfileModel>> getContacts(User user) {
    return _firebaseFirestore.collection('users').where('uid', isNotEqualTo: user.uid).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((DocumentSnapshot doc) {
        return UserProfileModel.fromDocumentSnapshot(doc);
      }).toList();
    });
  }

  Future<void> createChat(UserProfileEntity currentUser, UserProfileEntity otherUser) {
    return _firebaseFirestore.collection('chats').add({
      'participants': [currentUser.uid, otherUser.uid],
      'displayNames': [currentUser.displayName, otherUser.displayName],
      'imageUrls': [currentUser.photoURL, otherUser.photoURL]
    }).onError((error, stackTrace) => throw (Exception(error)));
  }
}
