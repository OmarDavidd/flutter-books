class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime sentAt;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.sentAt,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final String parsedId = json['id']?.toString() ?? '';

    final int? timestampMillis = json['timestamp'] as int?;
    final DateTime parsedSentAt =
        timestampMillis != null
            ? DateTime.fromMillisecondsSinceEpoch(timestampMillis)
            : DateTime.now();

    final bool parsedIsRead = json['leido'] ?? false;

    return ChatMessage(
      id: parsedId,
      senderId: json['senderId']?.toString() ?? '',
      receiverId: json['receiverId']?.toString() ?? '',
      content: json['content'] ?? '',
      sentAt: parsedSentAt,
      isRead: parsedIsRead,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'receiverId': receiverId,
    'content': content,
    'timestamp': sentAt.toIso8601String(),
  };

  ChatMessage copyWith({bool? isRead}) {
    return ChatMessage(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      sentAt: sentAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
