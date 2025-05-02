import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // supabase setup
  await Supabase.initialize(
    url: 'https://xuzhqaxmxgiexdjarlpx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh1emhxYXhteGdpZXhkamFybHB4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0NTY5NjYsImV4cCI6MjA2MTAzMjk2Nn0.QTnZQYPimOnIJLcgvLjRAU1ROh_dF8ZjWgAA7qEtTXg',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: AuthGate());
  }
}
