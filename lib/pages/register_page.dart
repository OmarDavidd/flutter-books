import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/widgets/textStyleCustom.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();

  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PLa contraseñas no son iguales')),
      );
      return;
    }

    try {
      await authService.singUpWithEmailPassword(email, password);
      Navigator.pop(context);
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
        title: const Text('Register', style: TextStyle(color: Colors.white)),
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
              Text("Nombres:", style: textStyleCustom()),
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFFFFFFF),
                ),
              ),
              ElevatedButton(
                onPressed: register,
                child: const Text('Register'),
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
        /*
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 50),
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          TextField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
          ),
          ElevatedButton(onPressed: register, child: const Text('Register')),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Center(child: Text("Ya tienes cuenta? Inicia sesion")),
          ),
        ],*/
      ),
    );
  }
}
