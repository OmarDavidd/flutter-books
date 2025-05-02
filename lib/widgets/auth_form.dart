import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/textStyleCustom.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';

class AuthForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isRegister;

  const AuthForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.isRegister = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Correo Electronico:", style: textStyleCustom()),
        CustomTextField(
          controller: emailController,
          icon: Icons.email,
          label: 'correo@gmail.com',
        ),
        Text("Contraseña:", style: textStyleCustom()),
        CustomTextField(
          controller: passwordController,
          icon: Icons.lock,
          label: '********',
          isPassword: true,
        ),
      ],
    );
  }
}
