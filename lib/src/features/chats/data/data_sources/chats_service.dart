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

  Future<List<UserProfileModel>> getContacts(User user) async {
    final query = await _firebaseFirestore
        .collection('users')
        .where('uid', isNotEqualTo: user.uid)
        .get()
        .onError((error, stackTrace) => throw (Exception(error)));
    List<UserProfileModel> data = query.docs.map((e) => UserProfileModel.fromDocumentSnapshot(e)).toList();
    return data;
  }

  Future<ChatModel> createChat(UserProfileEntity currentUser, UserProfileEntity otherUser) async {
    // Check if the chat already exists
    QuerySnapshot query = await _firebaseFirestore
        .collection('chats')
        .where('participants', arrayContainsAny: [currentUser.uid])
        .get()
        .onError((error, stackTrace) => throw (Exception(error)));

    final hasChatWithOtherUser = query.docs.any((element) => List<String>.from(element['participants'] ?? []).contains(otherUser.uid));
    if (hasChatWithOtherUser) {
      // Chat already exists, do not create a new one
      return ChatModel.fromDocumentSnapshot(
          query.docs.singleWhere((element) => List<String>.from(element['participants'] ?? []).contains(otherUser.uid)));
    }

    // Chat doesn't exist, create a new one
    DocumentReference docRef = await _firebaseFirestore.collection('chats').add({
      'participants': [currentUser.uid, otherUser.uid],
      'displayNames': [currentUser.displayName, otherUser.displayName],
      'imageUrls': [currentUser.photoURL, otherUser.photoURL]
    }).onError((error, stackTrace) => throw (Exception(error)));
    final doc = await docRef.get().onError((error, stackTrace) => throw (Exception(error)));
    return ChatModel.fromDocumentSnapshot(doc);
  }
}
