import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String? _error;

  // Hardcoded credentials for prototype
  final _demoEmail = 'demo@aqua.io';
  final _demoPass = 'password123';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() {
    final e = _emailCtrl.text.trim();
    final p = _passCtrl.text;
    if (e == _demoEmail && p == _demoPass) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      setState(() {
        _error =
        'Invalid credentials (for demo use demo@aqua.io / password123)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 8,
            shadowColor: Colors.black26,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo or icon placeholder
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(Icons.water_drop, size: 48, color: Colors.blue),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Welcome to Smart Aqua',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to continue',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Email TextField
                  TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password TextField
                  TextField(
                    controller: _passCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Error message
                  if (_error != null) ...[
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blue,
                        elevation: 4,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Demo info
                  Text(
                    'Demo: demo@aqua.io / password123',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
