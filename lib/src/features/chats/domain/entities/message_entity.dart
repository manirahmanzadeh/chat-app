import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String messageId;
  final String senderUid;
  final String text;
  final DateTime timestamp;
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
