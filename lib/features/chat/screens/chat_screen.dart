import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/websocket_service.dart';
import '../services/chat_api_service.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late WebSocketService _webSocketService;
  bool _isLoading = true;
  String? _error;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      // Cargar mensajes existentes
      debugPrint(
        "Cargando mensajes para: ${widget.currentUserId} y ${widget.otherUserId}",
      );

      final messages = await ChatApiService.getMessages(
        widget.currentUserId,
        widget.otherUserId,
      );
      debugPrint("Mensajes cargados: ${messages.length}");

      setState(() {
        _messages.addAll(messages);
        _isLoading = false;
      });

      _scrollToBottom();

      // Configurar WebSocket
      _webSocketService = WebSocketService(
        onMessageReceived: _handleNewMessage,
        onConnected: () => print('Connected to WebSocket'),
        onError: (error) => _showError(error),
      );

      _webSocketService.connect(widget.currentUserId);
    } catch (e) {
      //
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load chat: $e';
        _isLoading = false;
      });
    }
  }

  void _handleNewMessage(ChatMessage message) {
    //
    if (_isDisposed) return;

    if (!mounted) {
      return;
    }

    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showError(String error) {
    //
    if (_isDisposed || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = ChatMessage(
      id: '',
      senderId: widget.currentUserId,
      receiverId: widget.otherUserId,
      content: _messageController.text.trim(),
      sentAt: DateTime.now(),
    );

    _messageController.clear();

    try {
      _webSocketService.sendMessage(message);
    } catch (e) {
      _showError('Failed to send message: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _webSocketService.disconnect();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.senderId == widget.currentUserId;
                final showDate =
                    index == 0 ||
                    _messages[index - 1].sentAt.day != message.sentAt.day;

                return MessageBubble(
                  message: message,
                  isMe: isMe,
                  showDate: showDate,
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
        ],
      ),
    );
  }
}
