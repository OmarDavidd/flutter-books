import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class ChatApiService {
  //static const String _baseUrl = 'https://books-ow9l.onrender.com/api/chat';
  static final String _baseUrl = 'http://52.90.173.247:8080/api/chat';

  static Future<List<ChatMessage>> getMessages(
    String userId1,
    String userId2,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/conversacion?usuario1Id=$userId1&usuario2Id=$userId2',
        ),
      );
      debugPrint('response ${response.statusCode.toString()}');

      if (response.statusCode == 200) {
        final List<dynamic> messagesJson = jsonDecode(response.body);
        debugPrint('response $messagesJson');

        return messagesJson.map((json) => ChatMessage.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching messages: $e');
    }
  }
}
