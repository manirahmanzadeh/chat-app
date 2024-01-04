import 'package:chatapp/src/features/auth/data/models/user_profile_model.dart';
import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:chatapp/src/features/chats/data/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatsService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<ChatModel>> getChats(User user) {
    return _firebaseFirestore.collection('chats').where('participants', arrayContains: user.uid).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ChatModel(
          chatId: doc.id,
          participants: List<String>.from(data['participants'] ?? []),
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

    List<String> deviceContactNumbers = await _getDeviceContactNumbers();
    List<UserProfileModel> data = query.docs
        .map((e) => UserProfileModel.fromDocumentSnapshot(e))
        .where((profile) => deviceContactNumbers.contains(_normalizePhoneNumber(profile.phoneNumber)))
        .toList();
    return data;
  }

  String _normalizePhoneNumber(String phoneNumber) {
    // Remove non-numeric characters
    String numericOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');
    numericOnly.replaceAll(' ', '');
    // Take the last 10 characters
    int endIndex = numericOnly.length;
    int startIndex = (endIndex > 10) ? endIndex - 10 : 0;
    String numberWithOutCode = numericOnly.substring(startIndex, endIndex);
    String firstDigits = startIndex > 0 ? numericOnly.substring(0, startIndex) : '';
    String countryDigits = firstDigits.contains('0') ? '+98' : '+$firstDigits';
    return countryDigits + numberWithOutCode;
  }

  Future<List<String>> _getDeviceContactNumbers() async {
    var status = await Permission.contacts.status;
    if (!status.isGranted) {
      await Permission.contacts.request();
      return _getDeviceContactNumbers();
    }
    Iterable<Contact> contacts = await ContactsService.getContacts();
    List<String> phoneNumbers = contacts
        .where((contact) => contact.phones!.isNotEmpty)
        .map((contact) => _normalizePhoneNumber(contact.phones!.first.value ?? ""))
        .toList();
    print(phoneNumbers);
    return phoneNumbers;
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
    }).onError((error, stackTrace) => throw (Exception(error)));
    final doc = await docRef.get().onError((error, stackTrace) => throw (Exception(error)));
    return ChatModel.fromDocumentSnapshot(doc);
  }
}
