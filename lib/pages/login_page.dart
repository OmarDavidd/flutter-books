import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/auth_form.dart';
import 'package:flutter_application_1/widgets/app_logo.dart';
import 'package:flutter_application_1/pages/register_page.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:flutter_application_1/auth/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginController = AuthController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
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
              const SizedBox(height: 60),
              AuthForm(
                emailController: _emailController,
                passwordController: _passwordController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CustomButton(
                  text: 'Iniciar Sesion',
                  onPressed:
                      () => _loginController.login(
                        context,
                        _emailController.text,
                        _passwordController.text,
                      ),
                ),
              ),
              GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    ),
                child: const Center(
                  child: Text("No tienes cuenta? Registrate"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
