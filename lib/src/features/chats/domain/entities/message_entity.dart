import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String senderUid;
  final String text;
  final DateTime timestamp;

  const MessageEntity({
    required this.senderUid,
    required this.text,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [senderUid, text, timestamp];
}
