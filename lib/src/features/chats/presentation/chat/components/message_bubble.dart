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
    required this.deleteMessage,
    required this.openEditMessage,
  });

  final MessageEntity message;
  final bool myMessage;
  final String? displayName;
  final Function(String) deleteMessage;
  final Function(MessageEntity) openEditMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: myMessage ? TextDirection.rtl : TextDirection.ltr,
      children: [
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.copy),
                      title: const Text('Copy'),
                      onTap: () async {
                        Clipboard.setData(ClipboardData(text: message.text));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            showCloseIcon: true,
                            content: Text('Text copied'),
                          ),
                        );
                      },
                    ),
                    if (myMessage)
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Edit'),
                        onTap: () {
                          openEditMessage(message);
                          Navigator.pop(context);
                        },
                      ),
                    if (myMessage)
                      ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text('Delete'),
                        onTap: () {
                          deleteMessage(message.messageId);
                          Navigator.pop(context);
                        },
                      ),
                  ],
                );
              },
            );
          },
          child: ChatBubble(
            clipper: ChatBubbleClipper1(
              type: myMessage ? BubbleType.sendBubble : BubbleType.receiverBubble,
            ),
            alignment: myMessage ? Alignment.centerRight : Alignment.centerLeft,
            margin: const EdgeInsets.only(bottom: 16),
            backGroundColor: myMessage ? Colors.blueGrey : Colors.white,
            elevation: 0,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.fileUrl != null && message.fileUrl!.isNotEmpty)
                    Image.network(
                      message.fileUrl!,
                      width: MediaQuery.sizeOf(context).width / 2,
                    ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: myMessage ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    formatDateTime(message.timestamp),
                    style: TextStyle(
                      color: myMessage ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
