import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../models/chat_message.dart';

class WebSocketService {
  StompClient? _stompClient;
  bool _isConnected = false;
  final ValueChanged<ChatMessage>? onMessageReceived;
  final VoidCallback? onConnected;
  final ValueChanged<String>? onError;

  WebSocketService({this.onMessageReceived, this.onConnected, this.onError});

  void connect(String userId) {
    if (_isConnected) {
      debugPrint('WebSocketService: Already connected, skipping connect.');
      return;
    }

    final String websocketBaseUrl = 'http://52.90.173.247:8080/ws';
    //final String websocketBaseUrl = 'http://10.0.2.2:8080/ws'; // <-- CAMBIADO de ws:// a http://
    // final String websocketBaseUrl = 'http://localhost:8080/ws'; // Para iOS Sim/Web/Desktop, o tu máquina si ejecutas en iOS físico

    _stompClient = StompClient(
      config: StompConfig(
        url: websocketBaseUrl, // Usar la URL con http://
        onConnect: (StompFrame frame) {
          _isConnected = true;
          debugPrint('WebSocketService: Conectado al servidor.');
          onConnected?.call();

          // Suscripción a mensajes públicos
          _stompClient?.subscribe(
            destination: '/topic/public',
            callback: (frame) {
              if (frame.body != null) {
                try {
                  final message = ChatMessage.fromJson(jsonDecode(frame.body!));
                  debugPrint(
                    'WebSocketService: Mensaje público recibido: ${message.content}',
                  );
                  onMessageReceived?.call(message);
                } catch (e) {
                  debugPrint(
                    'WebSocketService: Error parseando mensaje público: $e. Body: ${frame.body}',
                  );
                  onError?.call('Error parseando mensaje público: $e');
                }
              }
            },
          );

          // Suscripción a mensajes privados
          _stompClient?.subscribe(
            destination: '/user/$userId/queue/messages',
            callback: (frame) {
              if (frame.body != null) {
                try {
                  final message = ChatMessage.fromJson(jsonDecode(frame.body!));
                  debugPrint(
                    'WebSocketService: Mensaje privado recibido para $userId: ${message.content}',
                  );
                  onMessageReceived?.call(message);
                } catch (e) {
                  debugPrint(
                    'WebSocketService: Error parseando mensaje privado: $e. Body: ${frame.body}',
                  );
                  onError?.call('Error parseando mensaje privado: $e');
                }
              }
            },
          );
        },
        onWebSocketError: (dynamic error) {
          _isConnected = false;
          debugPrint('WebSocketService: Error de WebSocket: $error');
          onError?.call('WebSocket error: $error');
        },
        onStompError: (StompFrame frame) {
          debugPrint('WebSocketService: Error de STOMP: ${frame.body}');
          onError?.call('STOMP error: ${frame.body}');
        },
        onDisconnect: (StompFrame frame) {
          _isConnected = false;
          debugPrint(
            'WebSocketService: Desconectado del servidor: ${frame.body}',
          );
          onError?.call('Disconnected from server: ${frame.body}');
        },
        useSockJS: true, // Esto sigue siendo TRUE y es importante
        stompConnectHeaders: {'userId': userId},
        webSocketConnectHeaders: {'userId': userId},
        reconnectDelay: const Duration(seconds: 5),
        connectionTimeout: const Duration(seconds: 10),
      ),
    );

    _stompClient?.activate();
  }

  void sendMessage(ChatMessage message) {
    if (!_isConnected) {
      debugPrint(
        'WebSocketService: No conectado, no se pudo enviar el mensaje.',
      );
      onError?.call('Not connected to server');
      return;
    }

    _stompClient?.send(
      destination: '/app/chat.send', // ← CAMBIAR de vuelta a '/app/chat.send'
      body: jsonEncode(message.toJson()),
      headers: {'userId': message.senderId},
    );
    debugPrint('WebSocketService: Mensaje enviado: ${message.content}');
    debugPrint('mensaje ${message.toJson()}');
  }

  void disconnect() {
    if (_stompClient != null && _stompClient!.connected) {
      _stompClient?.deactivate();
      debugPrint('WebSocketService: Desconexión solicitada.');
    }
    _isConnected = false;
  }

  bool get isConnected => _isConnected;
}
