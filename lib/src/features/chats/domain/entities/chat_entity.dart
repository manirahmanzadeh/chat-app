import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String chatId;
  final List<String> participants;

  const ChatEntity({
    required this.chatId,
    required this.participants,
  });

  @override
  List<Object?> get props => [
        chatId,
        participants,
      ];
}
