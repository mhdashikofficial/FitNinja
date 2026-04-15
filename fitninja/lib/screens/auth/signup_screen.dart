import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/db_service.dart';
import '../../services/mail_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _weight = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  Future<void> _signup() async {
    setState(() => _loading = true);
    try {
      final otp = (100000 + Random().nextInt(900000)).toString();
      await DbService.performSignup(_name.text, int.parse(_age.text), int.parse(_weight.text), _email.text, _pass.text, otp);
      await MailService.sendVerificationOtp(_email.text, _name.text, otp);
      if (!mounted) return;
      Navigator.pushNamed(context, '/verify', arguments: _email.text);
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
            bottom: -100, right: -100,
            child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF2979FF).withOpacity(0.1), boxShadow: [BoxShadow(color: const Color(0xFF2979FF).withOpacity(0.1), blurRadius: 100, spreadRadius: 50)])),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  const Text("JOIN THE\nELITE", style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, height: 1.0, color: Colors.white)).animate().fadeIn().slideX(begin: -0.2),
                  const SizedBox(height: 8),
                  const Text("Create your FitNinja profile", style: TextStyle(color: Colors.grey, letterSpacing: 1)).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 48),
                  
                  _buildGlassField(_name, "Full Name", Icons.person_outline),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildGlassField(_age, "Age", Icons.calendar_today, kbd: TextInputType.number)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildGlassField(_weight, "Weight (kg)", Icons.monitor_weight_outlined, kbd: TextInputType.number)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildGlassField(_email, "Email", Icons.email_outlined),
                  const SizedBox(height: 16),
                  _buildGlassField(_pass, "Password", Icons.lock_outline_rounded, obscure: _obscure, suffix: IconButton(icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off, color: Colors.grey, size: 20), onPressed: () => setState(()=> _obscure = !_obscure))),
                  
                  const SizedBox(height: 40),
                  
                  ElevatedButton(
                    onPressed: _loading ? null : _signup,
                    child: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : const Text("INITIALIZE ACCOUNT"),
                  ).animate().fadeIn(delay: 400.ms).scale(),
                  
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("ALREADY REGISTERED? LOG IN", style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  ).animate().fadeIn(delay: 600.ms),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassField(TextEditingController controller, String hint, IconData icon, {bool obscure = false, Widget? suffix, TextInputType kbd = TextInputType.text}) {
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
            keyboardType: kbd,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF00E5FF), size: 20),
              suffixIcon: suffix,
              labelText: hint,
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
      ),
    );
  }
}
