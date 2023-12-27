import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String chatId;
  final List<String> participants;
  final List<String> displayNames;
  final List<String> imageUrls;

  const ChatEntity({
    required this.chatId,
    required this.participants,
    required this.displayNames,
    required this.imageUrls,
  });

  @override
  List<Object?> get props => [
        chatId,
        participants,
        displayNames,
        imageUrls,
      ];
}
