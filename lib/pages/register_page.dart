import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/app_logo.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:flutter_application_1/widgets/textStyleCustom.dart';
import 'package:flutter_application_1/auth/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authController = AuthController();

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF5E4B3B),
      ),
      body: Container(
        color: const Color(0xFFFFF8F0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppLogo(),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _nombreController,
                      icon: Icons.person,
                      label: 'Nombre',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: _apellidoController,
                      icon: Icons.person,
                      label: 'Apellido',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text("Correo Electronico:", style: textStyleCustom()),
              CustomTextField(
                controller: _emailController,
                icon: Icons.email,
                label: 'correo@gmail.com',
              ),
              const SizedBox(height: 16),
              Text("Contraseña:", style: textStyleCustom()),
              CustomTextField(
                controller: _passwordController,
                icon: Icons.lock,
                label: '********',
                isPassword: true,
              ),
              const SizedBox(height: 16),
              Text("Confirmar Contraseña:", style: textStyleCustom()),
              CustomTextField(
                controller: _confirmPasswordController,
                icon: Icons.lock_outline,
                label: '********',
                isPassword: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CustomButton(
                  text: 'Registrarse',
                  onPressed:
                      () => _authController.register(
                        context,
                        _emailController.text,
                        _passwordController.text,
                        _confirmPasswordController.text,
                      ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Center(
                  child: Text("Ya tienes cuenta? Inicia sesion"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
