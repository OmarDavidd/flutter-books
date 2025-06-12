import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/chat/screens/chat_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido al Chat')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Presiona el botón para iniciar un chat:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ChatScreen(
                          currentUserId: '2', // ID del usuario actual
                          otherUserId: '1', // ID del otro usuario
                          otherUserName: 'Omar', // Nombre para mostrar
                        ),
                  ),
                );
              },
              child: const Text('Ir al Chat'),
            ),
          ],
        ),
      ),
    );
  }
}
