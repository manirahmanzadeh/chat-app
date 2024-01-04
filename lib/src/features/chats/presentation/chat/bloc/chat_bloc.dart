import 'dart:async';
import 'dart:io';

import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';
import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';
import 'package:chatapp/src/features/chats/domain/usecases/delete_message_usecase.dart';
import 'package:chatapp/src/features/chats/domain/usecases/edit_message_usecase.dart';
import 'package:chatapp/src/features/chats/domain/usecases/get_messages_usecase.dart';
import 'package:chatapp/src/features/chats/domain/usecases/send_message_usecase.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/chat_state.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/sm.dart';
import 'package:chatapp/src/features/chats/presentation/contact/contact_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ChatBloc extends Cubit<ChatState> {
  final AuthRepository _authRepository;

  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final DeleteMessageUseCase _deleteMessageUseCase;
  final EditMessageUseCase _editMessageUseCase;

  late BuildContext _context;
  late ChatEntity _chat;
  late Stream<List<MessageEntity>> _messageStream;
  late UserProfileEntity _userProfile;
  final List<SM> _sending = [];

  MessageEntity? _targetMessage;
  final TextEditingController messageController = TextEditingController();
  File? file;

  User get currentUser => _authRepository.getCurrentUser()!;

  ChatBloc(
    this._authRepository,
    this._getMessagesUseCase,
    this._sendMessageUseCase,
    this._deleteMessageUseCase,
    this._editMessageUseCase,
  ) : super(const LoadingChatState());

  setFile() {
    _showImagePicker(_context);
  }

  void _showImagePicker(BuildContext screenContext) {
    showModalBottomSheet(
      context: screenContext,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                _pickImage(ImageSource.gallery, screenContext);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                _pickImage(ImageSource.camera, screenContext);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(
    ImageSource source,
    BuildContext context,
  ) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      file = File(pickedFile.path);
      emit(FileSelectedChatState(_chat, _messageStream, _userProfile, file!, _sending));
    }
  }

  closeTargetMessage() {
    _targetMessage = null;
    messageController.clear();
    emit(LoadedChatState(_chat, _messageStream, _userProfile, _sending));
  }

  closeFileUpload() {
    file = null;
    emit(LoadedChatState(_chat, _messageStream, _userProfile, _sending));
  }

  FutureOr<void> initChat(BuildContext context, ChatEntity chat, UserProfileEntity userProfile) {
    emit(
      const LoadingChatState(),
    );
    try {
      final messagesStream = _getMessagesUseCase(params: chat.chatId);
      _chat = chat;
      _userProfile = userProfile;
      _messageStream = messagesStream;
      _context = context;
      emit(LoadedChatState(_chat, _messageStream, _userProfile, _sending));
    } on Exception catch (e) {
      emit(
        ErrorChatState(e),
      );
    }
  }

  FutureOr<void> sendMessage() async {
    String message = messageController.text.trim();
    if (message.isEmpty && file == null) {
      return;
    }
    try {
      final newSendingMessage = SM(
        text: message,
        file: file,
        fileType: 'Photo',
      );
      _sending.add(newSendingMessage);
      _sendMessageUseCase(params: {
        'chatId': _chat.chatId,
        'senderUid': currentUser.uid,
        'text': message,
        'onDone': () {
          _sending.remove(newSendingMessage);
          emit(LoadedChatState(_chat, _messageStream, _userProfile, _sending));
        },
        'file': file,
        'fileType': 'Photo',
        'onUploadProgress': newSendingMessage.onUploadProgress
      });
      file = null;
      messageController.clear();
      emit(SendingMessageChatState(_chat, _messageStream, _userProfile, _sending));
    } on Exception catch (e) {
      print(e);
      emit(
        ErrorChatState(e),
      );
    }
  }

  FutureOr<void> deleteMessage(String messageId) async {
    try {
      await _deleteMessageUseCase(params: {
        'chatId': _chat.chatId,
        'messageId': messageId,
      });
    } on Exception catch (e) {
      emit(
        ErrorChatState(e),
      );
    }
  }

  FutureOr<void> openEditMessage(MessageEntity message) {
    messageController.value = TextEditingValue(text: message.text);
    _targetMessage = message;
    emit(
      EditingChatState(_chat, _messageStream, _userProfile, message, _sending),
    );
  }

  FutureOr<void> submitEditMessage() async {
    try {
      String newText = messageController.text.trim();
      if (newText.isNotEmpty) {
        _editMessageUseCase(params: {
          'chatId': _chat.chatId,
          'messageId': _targetMessage!.messageId,
          'newText': newText,
        });
        emit(LoadedChatState(_chat, _messageStream, _userProfile, _sending));
        _targetMessage = null;
        messageController.clear();
      }
    } on Exception catch (e) {
      emit(
        ErrorChatState(e),
      );
    }
  }

  void goToContact() {
    Navigator.pushNamed(_context, ContactScreen.routeName, arguments: _userProfile);
  }
}
