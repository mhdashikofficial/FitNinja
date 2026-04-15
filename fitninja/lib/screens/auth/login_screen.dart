import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/db_service.dart';
import '../../services/app_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      final user = await DbService.login(_email.text, _pass.text);
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', _email.text);
        await prefs.setString('userName', user['name'] ?? 'User');
        await prefs.setInt('userAge', user['age'] ?? 25);
        await prefs.setInt('userWeight', user['weight'] ?? 70);
        await prefs.setBool('onboardingCompleted', user['onboardingCompleted'] ?? false);
        
        // SYNC DATA BEFORE NAVIGATION
        await AppData.init();
        
        if (!mounted) return;
        if (user['onboardingCompleted'] == true) {
            Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
            Navigator.pushReplacementNamed(context, '/onboarding');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -100, left: -100,
            child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF00E5FF).withOpacity(0.1), boxShadow: [BoxShadow(color: const Color(0xFF00E5FF).withOpacity(0.1), blurRadius: 100, spreadRadius: 50)])),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("WELCOME\nBACK", style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, height: 1.0, color: Colors.white)).animate().fadeIn().slideX(begin: -0.2),
                  const SizedBox(height: 8),
                  const Text("Sign in to your Ninja-Core", style: TextStyle(color: Colors.grey, letterSpacing: 1)).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 48),
                  
                  _buildGlassField(_email, "Email", Icons.email_outlined),
                  const SizedBox(height: 20),
                  _buildGlassField(_pass, "Password", Icons.lock_outline_rounded, obscure: true),
                  const SizedBox(height: 40),
                  
                  ElevatedButton(
                    onPressed: _loading ? null : _login,
                    child: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : const Text("ENGAGE SESSION"),
                  ).animate().fadeIn(delay: 400.ms).scale(),
                  
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text("INITIALIZE NEW ACCOUNT", style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  ).animate().fadeIn(delay: 600.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassField(TextEditingController controller, String hint, IconData icon, {bool obscure = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF00E5FF), size: 20),
              labelText: hint,
              labelStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
      ),
    );
  }
}
