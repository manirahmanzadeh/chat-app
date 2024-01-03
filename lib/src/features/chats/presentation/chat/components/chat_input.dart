import 'dart:io';

import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';
import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({
    Key? key,
    required this.onSendMessage,
    required this.messageController,
    this.editingMessage,
    required this.closeTargetMessage,
    required this.submitEditMessage,
    required this.attachFile,
    this.file,
    this.closeFileUpload,
  }) : super(key: key);

  final Function() onSendMessage;
  final TextEditingController messageController;
  final MessageEntity? editingMessage;
  final Function()? submitEditMessage;
  final Function()? closeTargetMessage;
  final Function()? closeFileUpload;
  final Function() attachFile;
  final File? file;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (file != null)
          Container(
            color: Colors.white70,
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.attach_file,
                  color: Colors.blueGrey,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'File',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Image.file(
                        file!,
                        height: 50,
                        width: 50,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: closeFileUpload,
                  child: const Icon(
                    Icons.close,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
        if (editingMessage != null)
          Container(
            color: Colors.white70,
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.edit,
                  color: Colors.blueGrey,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Edit Message',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        editingMessage!.text,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black38,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: closeTargetMessage,
                  child: const Icon(
                    Icons.close,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.send,
                  maxLines: null,
                  onChanged: (value) {
                    // Perform any additional actions when text changes.
                    // For example, you can update the UI based on the current text value.
                  },
                  onSubmitted: (_) => onSendMessage,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: attachFile,
              ),
              if (editingMessage != null)
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: submitEditMessage,
                )
              else
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: onSendMessage,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
