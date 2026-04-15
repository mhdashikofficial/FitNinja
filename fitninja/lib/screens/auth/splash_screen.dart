import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/app_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Start pre-loading data
    final dataInit = AppData.init();
    
    // Ensure animation plays for at least 2.5 seconds for dramatic effect
    await Future.wait([
      dataInit,
      Future.delayed(const Duration(milliseconds: 2800)),
    ]);

    if (!mounted) return;

    // Navigate to appropriate screen
    if (AppData.userEmail == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else if (!AppData.onboardingCompleted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF010101),
      body: Stack(
        children: [
          // Background Gradient Glow
          Center(
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: const Color(0xFF00E5FF).withOpacity(0.15), blurRadius: 100, spreadRadius: 50)
                ]
              ),
            ),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // The Ninja Logo with Slice Animation
                Image.asset('assets/images/logo.png', width: 140)
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), curve: Curves.elasticOut, duration: 1200.ms)
                  .shimmer(delay: 1500.ms, duration: 800.ms, color: Colors.white24),
                
                const SizedBox(height: 32),
                
                // Blade Slash Effect (Visual bar that zips over)
                Container(
                  width: 100, height: 2,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.transparent, Color(0xFF00E5FF), Colors.transparent])
                  ),
                ).animate()
                 .slideX(begin: -2, end: 2, delay: 1200.ms, duration: 600.ms, curve: Curves.fastOutSlowIn)
                 .fadeOut(delay: 1700.ms),

                const SizedBox(height: 16),
                
                const Text("FITNINJA AI", 
                  style: TextStyle(letterSpacing: 8, fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18))
                  .animate()
                  .fadeIn(delay: 1000.ms)
                  .blur(begin: const Offset(10, 0), end: const Offset(0, 0), delay: 1000.ms),
              ],
            ),
          ),
          
          // Subtle scanner lines
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: ListView.builder(
                itemBuilder: (c, i) => const Divider(color: Colors.white, height: 4),
              ),
            ),
          )
        ],
      ),
    );
  }
}
