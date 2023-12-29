import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String messageId;
  final String senderUid;
  final String text;
  final Timestamp timestamp;
  final bool edited;

  const MessageEntity({
    required this.messageId,
    required this.senderUid,
    required this.text,
    required this.timestamp,
    this.edited = false,
  });

  @override
  List<Object?> get props => [messageId, senderUid, text, timestamp];
}
