import 'package:flutter/material.dart';
import '../../services/db_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WizardScreen extends StatefulWidget {
  const WizardScreen({super.key});
  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  int _step = 1;
  final _loc = TextEditingController();
  final _time = TextEditingController();
  final List<String> _equipment = [];
  final List<String> _options = ["Dumbbells", "Stretching bands", "Punching bag", "Gloves"];
  bool _loading = false;

  void _finish() async {
    setState((){ _loading = true; });
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    if (email != null) {
      await DbService.saveOnboarding(email, _loc.text, _time.text, _equipment);
      await prefs.setBool('onboardingCompleted', true);
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_step == 1) ...[
                const Text("Where are you located?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextField(controller: _loc, decoration: const InputDecoration(labelText: "City, Country", filled: true)),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: () => setState(()=>_step=2), child: const Text("Next"))
              ],
              if (_step == 2) ...[
                const Text("Preferred Workout Time?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextField(controller: _time, decoration: const InputDecoration(labelText: "e.g. 07:00 AM", filled: true)),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: () => setState(()=>_step=3), child: const Text("Next"))
              ],
              if (_step == 3) ...[
                const Text("What equipment do you have?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: _options.map((e) {
                    final selected = _equipment.contains(e);
                    return ChoiceChip(
                      label: Text(e),
                      selected: selected,
                      onSelected: (val) => setState(() { val ? _equipment.add(e) : _equipment.remove(e); }),
                    );
                  }).toList()
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _loading ? null : _finish,
                  child: _loading ? const CircularProgressIndicator() : const Text("Finish Setup")
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
