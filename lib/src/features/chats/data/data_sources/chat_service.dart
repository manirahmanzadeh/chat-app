import 'dart:io';

import 'package:chatapp/src/features/chats/data/models/message_model.dart';
import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _firebaseStorage = firebase_storage.FirebaseStorage.instance;

  Stream<List<MessageEntity>> getChatMessages(String chatId) {
    return _firebaseFirestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return MessageModel.fromMap(data, doc.id);
      }).toList();
    });
  }

  Future<void> createMessage(
    String chatId,
    String senderUid,
    Function() onDone,
    String text,
    File? file,
    String? fileType,
    Function(double)? onUploadProgress,
  ) async {
    String? fileUrl;

    print('my file');
    print(file);
    if (file != null) {
      print('there is file');
      fileUrl = await _uploadFile(chatId, file, onUploadProgress);
    }

    await _firebaseFirestore.collection('chats').doc(chatId).collection('messages').add({
      'senderUid': senderUid,
      'text': text,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'timestamp': FieldValue.serverTimestamp(),
    }).onError((error, stackTrace) => throw (Exception(error)));
    onDone();
  }

  Future<String?> _uploadFile(String chatId, File file, Function(double)? onProgress) async {
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

    firebase_storage.Reference ref = _firebaseStorage.ref('chats/$chatId/$fileName');
    firebase_storage.UploadTask uploadTask = ref.putFile(file);

    // Listen for updates on the upload progress
    uploadTask.snapshotEvents.listen(
      (firebase_storage.TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
        if (onProgress != null) {
          onProgress(progress);
        }
      },
      onError: (Object e) {
        throw (e);
      },
      onDone: () {
        print('Upload complete');
      },
      cancelOnError: true,
    );

    await uploadTask.onError((error, stackTrace) => throw (Exception(error)));

    String downloadUrl = await ref.getDownloadURL().onError((error, stackTrace) => throw (Exception(error)));

    print(downloadUrl);
    return downloadUrl;
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    return _firebaseFirestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete()
        .onError((error, stackTrace) => throw (Exception(error)));
  }

  Future<void> editMessage(String chatId, String messageId, String newText) async {
    return _firebaseFirestore.collection('chats').doc(chatId).collection('messages').doc(messageId).update({
      'text': newText,
      'edited': true,
    }).onError((error, stackTrace) => throw (Exception(error)));
  }
}
