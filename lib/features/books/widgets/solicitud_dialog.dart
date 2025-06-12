import 'package:flutter/material.dart';

class SolicitudDialog {
  static Future<Map<String, dynamic>?> mostrar({
    required BuildContext context,
  }) async {
    final controller = TextEditingController();
    int duracion = 7; // Valor por defecto

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Solicitar libro"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Mensaje al propietario",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: duracion,
                items:
                    [7, 14, 21].map((days) {
                      return DropdownMenuItem<int>(
                        value: days,
                        child: Text("$days días"),
                      );
                    }).toList(),
                onChanged: (value) => duracion = value!,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed:
                  () => Navigator.pop(context, {
                    'mensaje': controller.text,
                    'duracion': duracion,
                  }),
              child: const Text("Enviar"),
            ),
          ],
        );
      },
    );
  }
}
