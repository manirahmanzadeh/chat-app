import 'package:chatapp/src/core/utils/date_formatter.dart';
import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.myMessage,
    this.displayName,
  });

  final MessageEntity message;
  final bool myMessage;
  final String? displayName;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: myMessage ? TextDirection.rtl : TextDirection.ltr,
      children: [
        ChatBubble(
          clipper: ChatBubbleClipper1(
            type: myMessage ? BubbleType.sendBubble : BubbleType.receiverBubble,
          ),
          alignment: myMessage ? Alignment.centerRight : Alignment.centerLeft,
          margin: const EdgeInsets.only(bottom: 16),
          backGroundColor: Colors.white,
          elevation: 0,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!myMessage)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: TextDirection.ltr,
                    children: [
                      PopupMenuButton<String>(
                        onSelected: (String item) async {
                          if (item == 'copy') {
                            await Clipboard.setData(ClipboardData(text: message.text));
                          }
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        color: Colors.white,
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'copy',
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: const Text('Copy'),
                          ),
                        ],
                        child: const Icon(Icons.more_vert),
                      ),
                      Expanded(
                        child: Text(
                          displayName!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  message.text,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  formatDateTime(message.timestamp),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.black38,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
