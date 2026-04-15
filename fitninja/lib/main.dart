import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/db_service.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/verify_screen.dart';
import 'screens/onboarding/wizard_screen.dart';
import 'screens/main/dashboard_screen.dart';
import 'screens/main/analysis_screen.dart';
import 'screens/main/tutorials_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbService.connect();
  runApp(const FitNinjaApp());
}

class FitNinjaApp extends StatelessWidget {
  const FitNinjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitNinja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        // Premium Typography
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
          displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: Colors.white),
          titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFF2979FF),
          surface: Color(0xFF1C1C1E),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF0A0A0A),
          elevation: 0,
          titleTextStyle: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00E5FF),
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      // Starts with the Animated Splash Screen
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/verify': (context) => const VerifyScreen(),
        '/onboarding': (context) => const WizardScreen(),
        '/dashboard': (context) => const MainTabs(),
      },
    );
  }
}

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});
  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _currentIndex = 0;
  final List<Widget> _screens = [const DashboardScreen(), const AnalysisScreen(), const TutorialsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05)))
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF111111),
          selectedItemColor: const Color(0xFF00E5FF),
          unselectedItemColor: Colors.grey.withOpacity(0.5),
          currentIndex: _currentIndex,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'PLAN'),
            BottomNavigationBarItem(icon: Icon(Icons.insert_chart), label: 'STATS'),
            BottomNavigationBarItem(icon: Icon(Icons.school), label: 'LEARN'),
          ],
        ),
      ),
    );
  }
}
