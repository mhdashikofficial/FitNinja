import 'package:flutter/material.dart';
import '../../services/db_service.dart';
import '../../services/app_data.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});
  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _otp = TextEditingController();
  bool _loading = false;

  Future<void> _verify(String email) async {
    setState(() => _loading = true);
    try {
      bool success = await DbService.verifyOtp(email, _otp.text);
      if (success) {
        // Pre-sync if possible
        await AppData.init();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;
    
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Check your Spam Folder", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 24),
            TextField(controller: _otp, keyboardType: TextInputType.number, textAlign: TextAlign.center, decoration: const InputDecoration(labelText: "6-Digit Code", filled: true)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : () => _verify(email),
              child: Padding(padding: const EdgeInsets.all(16), child: _loading ? const CircularProgressIndicator() : const Text("Verify Account")),
            ),
          ],
        ),
      ),
    );
  }
}
