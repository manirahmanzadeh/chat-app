import 'package:chatapp/src/features/chats/presentation/chat/bloc/sm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class SMBubble extends StatelessWidget {
  const SMBubble({
    super.key,
    required this.sm,
  });

  final SM sm;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
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
                        Clipboard.setData(ClipboardData(text: sm.text));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            showCloseIcon: true,
                            content: Text('Text copied'),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: ChatBubble(
            clipper: ChatBubbleClipper1(
              type: BubbleType.sendBubble,
            ),
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 16),
            backGroundColor: Colors.blueGrey.withOpacity(0.6),
            elevation: 0,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sm.file != null)
                    // TODO: for now we just handle images
                    Stack(
                      children: [
                        Image.file(
                          sm.file!,
                          width: MediaQuery.sizeOf(context).width / 2,
                        ),
                        CircularProgressIndicator(
                          value: sm.progress,
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    sm.text,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Icon(
                    Icons.access_time,
                    color: Colors.white38,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
