import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/textStyleCustom.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await authService.singInWithEmailPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF5E4B3B),
      ),
      body: Container(
        color: Color(0xFFFFF8F0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "A  T  I  U  M",
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: "Roboto",
                    color: Color(0xFF5E4B3B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Text("Correo Electronico:", style: textStyleCustom()),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'correo@gmail.com',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFFFFFFF),
                ),
              ),
              Text("Contraseña:", style: textStyleCustom()),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: '********',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFFFFFFF),
                ),
                obscureText: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(
                        0xFFD4A373,
                      ), // Cambia el color de fondo
                      foregroundColor:
                          Colors.white, // Cambia el color del texto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // Bordes redondeados
                      ),
                    ),
                    child: const Text(
                      'Iniciar Sesion',
                      style: TextStyle(
                        fontSize: 18, // Cambia el tamaño del texto
                        fontWeight: FontWeight.bold, // Cambia el peso del texto
                      ),
                    ),
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
