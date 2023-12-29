import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static const routeName = '/chat';

  @override
  Widget build(BuildContext context) {
    final chat = ModalRoute.of(context)!.settings.arguments as ChatEntity;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              height: 32,
              child: ClipOval(
                child: CachedNetworkImage(imageUrl: chat.imageUrls[1]),
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(chat.displayNames[1])
          ],
        ),
      ),
    );
  }
}
