import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final bool showDate;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.showDate = false,
  });
  // const Color(0xFFD4A373)
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (showDate)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Center(
              child: Text(
                DateFormat('MMMM d, y').format(message.sentAt),
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: isMe ? const Color(0xFFD4A373) : Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 12 : 0),
              topRight: Radius.circular(isMe ? 0 : 12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('HH:mm').format(message.sentAt),
                style: TextStyle(
                  color: isMe ? Colors.white70 : Colors.grey[600],
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
