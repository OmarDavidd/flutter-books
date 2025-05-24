import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String label;
  final bool isPassword;
  final TextInputType? keyboardType;
  final String? Function(String?)?
  validator; // <--- ¡Aquí ya lo tienes declarado!

  const CustomTextField({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    this.isPassword = false,
    this.keyboardType,
    this.validator, // <--- ¡Aquí ya lo tienes en el constructor!
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // <--- ¡CAMBIO CLAVE AQUÍ: de TextField a TextFormField!
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
      ),
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator, // <--- ¡Aquí es donde lo asignas al TextFormField!
    );
  }
}
