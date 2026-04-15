import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fitninja/models/tutorial_data.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  bool _isNinjaMode = false;
  bool _isNinjaUnlocked = false;
  int _totalMasteryPoints = 0;
  final TextEditingController _passwordController = TextEditingController();

  void _unlockNinja() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: Color(0xFF00E5FF), width: 0.5)),
        title: const Text("RESTRICTED ACCESS", style: TextStyle(color: Color(0xFF00E5FF), letterSpacing: 2, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter the master code to reveal the Shinobi archives.", style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 24),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter Code",
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL", style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            onPressed: () {
              if (_passwordController.text == "ash1111") {
                setState(() {
                  _isNinjaUnlocked = true;
                  _isNinjaMode = true;
                });
                Navigator.pop(context);
              }
              _passwordController.clear();
            },
            child: const Text("UNLOCK"),
          ),
        ],
      ),
    );
  }

  String _getRankTitle() {
    if (_totalMasteryPoints < 100) return "INITIATE";
    if (_totalMasteryPoints < 300) return "OPERATIVE";
    if (_totalMasteryPoints < 600) return "TACTICAL SPECIALIST";
    return "SHINOBI GHOST";
  }

  @override
  Widget build(BuildContext context) {
    Color themeColor = _isNinjaMode ? const Color(0xFF00E5FF) : const Color(0xFF4A90E2);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_isNinjaMode ? "assets/tutorials/masters/ninja_stealth.png" : "assets/tutorials/masters/boxing_strike.png"),
            fit: BoxFit.cover,
            opacity: 0.05,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(themeColor),
              _buildHemisphereSwitcher(themeColor),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  children: _isNinjaMode 
                    ? ninjaDisciplines.map((d) => _buildDisciplineRow(d, themeColor)).toList()
                    : boxingDisciplines.map((d) => _buildDisciplineRow(d, themeColor)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color themeColor) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_isNinjaMode ? "SHINOBI VAULT" : "ELITE PRO GYM", 
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: themeColor.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                    child: Text(_getRankTitle(), style: TextStyle(color: themeColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ),
                  const SizedBox(width: 8),
                  Text("${_totalMasteryPoints}PTS", style: const TextStyle(color: Colors.white38, fontSize: 10)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white12)),
            child: Icon(_isNinjaMode ? Icons.remove_red_eye : Icons.fitness_center, color: themeColor, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildHemisphereSwitcher(Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 50,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isNinjaMode = false),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: !_isNinjaMode ? const Color(0xFF4A90E2).withOpacity(0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text("BOXING", style: TextStyle(color: !_isNinjaMode ? const Color(0xFF4A90E2) : Colors.white24, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _isNinjaUnlocked ? setState(() => _isNinjaMode = true) : _unlockNinja(),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _isNinjaMode ? const Color(0xFF00E5FF).withOpacity(0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("SHINOBI", style: TextStyle(color: _isNinjaMode ? const Color(0xFF00E5FF) : Colors.white24, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      if (!_isNinjaUnlocked) ...[const SizedBox(width: 8), const Icon(Icons.lock, size: 12, color: Colors.white12)],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisciplineRow(TrainingDiscipline discipline, Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(discipline.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1)),
                  Text(discipline.description, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                ],
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white12, size: 14),
            ],
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: discipline.modules.length,
            itemBuilder: (context, index) {
              TrainingModule module = discipline.modules[index];
              return _buildModuleCard(module, themeColor);
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildModuleCard(TrainingModule module, Color themeColor) {
    return GestureDetector(
      onTap: () => _showDetail(module, themeColor),
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: module.isMastered ? themeColor.withOpacity(0.3) : Colors.white.withOpacity(0.05)),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(module.masterArt, width: double.infinity, fit: BoxFit.cover, opacity: const AlwaysStoppedAnimation(0.6)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(module.title, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold), maxLines: 1),
                      Text(module.subtitle, style: const TextStyle(color: Colors.white38, fontSize: 9)),
                    ],
                  ),
                ),
              ],
            ),
            if (module.isMastered)
              Positioned(top: 8, right: 8, child: Icon(Icons.check_circle, color: themeColor, size: 16)),
          ],
        ),
      ),
    );
  }

  void _showDetail(TrainingModule module, Color themeColor) {
    // Check for Genjutsu Warning
    if (module.id.startsWith("gen")) {
      _showGenjutsuWarning(() => _openDetailSheet(module, themeColor));
    } else {
      _openDetailSheet(module, themeColor);
    }
  }

  void _showGenjutsuWarning(VoidCallback onAccept) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: Colors.redAccent, width: 1)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 12),
            Text("GENJUTSU CAUTION", style: TextStyle(color: Colors.redAccent, letterSpacing: 1)),
          ],
        ),
        content: const Text(
          "These psychological tactics (Misdirection, PsyOps) are powerful and for defensive/educational use only. Misuse can lead to severe ethical and legal consequences. Proceed with total responsibility.",
          style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL", style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              onAccept();
            },
            child: const Text("I UNDERSTAND"),
          ),
        ],
      ),
    );
  }

  void _openDetailSheet(TrainingModule module, Color themeColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161618),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    Image.asset(module.masterArt, height: 250, width: double.infinity, fit: BoxFit.cover),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.8)]),
                      ),
                    ),
                    Positioned(
                      bottom: 20, left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(module.title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text(module.subtitle, style: TextStyle(color: themeColor, letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("MODERN REALIST ADAPTATION", style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(module.masterLore, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.6, fontStyle: FontStyle.italic)),
                      const SizedBox(height: 24),
                      const Text("TECHNICAL BREAKDOWN", style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(module.description, style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.6)),
                      const SizedBox(height: 32),
                      const Text("DISCIPLINE DRILLS", style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ...module.tips.map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.bolt, color: themeColor, size: 18),
                            const SizedBox(width: 12),
                            Expanded(child: Text(tip, style: const TextStyle(color: Colors.white70, fontSize: 14))),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (!module.isMastered)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    setState(() {
                      module.isMastered = true;
                      _totalMasteryPoints += module.rankPoints;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("MASTER THIS TECHNIQUE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                )
              else
                Container(
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border.all(color: themeColor), borderRadius: BorderRadius.circular(20)),
                  child: Text("TECHNIQUE MASTERED", style: TextStyle(color: themeColor, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
