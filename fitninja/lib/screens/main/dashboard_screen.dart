import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../services/ai_service.dart';
import '../../services/db_service.dart';
import '../../services/app_data.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // All state is now primarily managed by AppData for instant loading
  bool _syncing = false;

  @override
  Widget build(BuildContext context) {
    final workouts = AppData.currentPlan?["workout_plan"] as List? ?? [];
    final focus = AppData.currentPlan?["focus"] ?? "NINJA MODE";
    final isSunday = AppData.currentPlan?["is_rest_day"] ?? false;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient base
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0A0A0A), Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
              ),
            ),
          ),
          
          // Floating Glow Orbs for "Ninja" atmosphere
          Positioned(
            top: -100, right: -100,
            child: _buildGlowOrb(const Color(0xFF00E5FF).withOpacity(0.1), 300),
          ),
          Positioned(
            bottom: 100, left: -50,
            child: _buildGlowOrb(const Color(0xFF2979FF).withOpacity(0.05), 250),
          ),

          RefreshIndicator(
            onRefresh: () async => _refreshData(),
            color: const Color(0xFF00E5FF),
            backgroundColor: const Color(0xFF1C1C1E),
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeaderSection(focus, isSunday),
                      const SizedBox(height: 32),
                      
                      _buildMacroSection(),
                      const SizedBox(height: 40),
                      
                      _buildSectionTitle("Daily Protocol", "Detailed Training Plan"),
                      const SizedBox(height: 16),
                      if (workouts.isNotEmpty)
                        ...workouts.asMap().entries.map((e) => _buildGlassWorkoutTile(e.value, e.key)).toList()
                      else
                        _buildEmptyState(isSunday),

                      const SizedBox(height: 32),
                      _buildSectionTitle("Boxing Strategy", "Tactical HUD Analysis"),
                      const SizedBox(height: 16),
                      _buildBoxingStrategyCard(),
                      
                      const SizedBox(height: 100), // Bottom padding
                    ]),
                  ),
                ),
              ],
            ),
          ),
          
          // Background sync indicator
          if (_syncing)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 20,
              child: const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF00E5FF))).animate().fade(),
            ),
        ],
      ),
    );
  }

  Widget _buildGlowOrb(Color color, double size) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)]),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: false,
      title: const Text("DASHBOARD", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w900, fontSize: 16)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
            child: const Icon(Icons.person, size: 20, color: Color(0xFF00E5FF)),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildHeaderSection(String focus, bool isSunday) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Hi ${AppData.userName?.split(' ')[0] ?? 'Ninja'}, Ready?", 
              style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.normal)).animate().fadeIn(duration: 600.ms),
            const Spacer(),
            if (isSunday) 
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.greenAccent.withOpacity(0.3))),
                child: const Text("REST DAY", style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
              ).animate().shake(delay: 1.seconds),
          ],
        ),
        const SizedBox(height: 4),
        Text(focus.toUpperCase(), 
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1))
          .animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
        const SizedBox(height: 4),
        Text(DateFormat('EEEE, MMM d').format(DateTime.now()).toUpperCase(), 
          style: const TextStyle(fontSize: 12, color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, letterSpacing: 2))
          .animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildMacroSection() {
    return Row(
      children: [
        _buildGlassMacroCard("CALORIES", AppData.todayMacros?["calories"] ?? 0, Icons.flash_on, const Color(0xFFFF9100)),
        const SizedBox(width: 16),
        _buildGlassMacroCard("PROTEIN", AppData.todayMacros?["protein"] ?? 0, Icons.fitness_center, const Color(0xFF00E5FF), target: AppData.proteinGoal),
        const SizedBox(width: 16),
        _buildAddMealGlassButton(),
      ],
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1);
  }

  Widget _buildGlassMacroCard(String label, int value, IconData icon, Color color, {int? target}) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 12),
                Text(target != null ? "$value/$target" : value.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.withOpacity(0.8), letterSpacing: 1, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddMealGlassButton() {
    return GestureDetector(
      onTap: () => _showMealLogger(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF00E5FF).withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.2)),
            ),
            child: const Icon(Icons.add_a_photo_rounded, color: Color(0xFF00E5FF), size: 32),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildGlassWorkoutTile(dynamic workout, int index) {
    final title = workout["item"]?.toString() ?? "Exercise";
    final subtitle = workout["instruction"]?.toString() ?? "Training detail";
    bool done = (AppData.todayMacros?["completed_items"] as List? ?? []).contains(title);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AnimatedContainer(
            duration: 300.ms,
            decoration: BoxDecoration(
              color: done ? Colors.greenAccent.withOpacity(0.05) : Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: done ? Colors.greenAccent.withOpacity(0.2) : Colors.white.withOpacity(0.05)),
            ),
            child: CheckboxListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              value: done,
              onChanged: (val) => _toggleWorkout(title, val),
              activeColor: Colors.greenAccent,
              checkColor: Colors.black,
              title: Text(title, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: done ? Colors.grey : Colors.white)),
              subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.withOpacity(0.7))),
              secondary: Icon(Icons.fitness_center_rounded, color: done ? Colors.greenAccent.withOpacity(0.3) : const Color(0xFF00E5FF).withOpacity(0.6)),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (200 + index * 50).ms).slideX(begin: 0.05);
  }

  Widget _buildBoxingStrategyCard() {
    final drills = AppData.currentPlan?["boxing_drills"] as List? ?? [];
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFF00E5FF).withOpacity(0.1), const Color(0xFF2979FF).withOpacity(0.05)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...drills.map((d) {
                final drillName = d['drill']?.toString() ?? "Drill";
                bool done = (AppData.todayMacros?["completed_items"] as List? ?? []).contains(drillName);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white24),
                        child: Checkbox(
                          value: done,
                          activeColor: const Color(0xFF00E5FF),
                          onChanged: (val) => _toggleWorkout(drillName, val),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(drillName, style: TextStyle(color: done ? Colors.grey : Colors.white, fontWeight: FontWeight.bold, fontSize: 16, decoration: done ? TextDecoration.lineThrough : null)),
                            const SizedBox(height: 4),
                            Text(d['details']?.toString() ?? "", style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const Divider(color: Colors.white10),
              const Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Color(0xFF00E5FF), size: 14),
                  SizedBox(width: 8),
                  Text("MANUAL TRACKING ACTIVE", style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1)),
                ],
              )
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 1.seconds);
  }

  Widget _buildEmptyState(bool isRestDay) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(child: Text(isRestDay ? "ENJOY YOUR RECOVERY" : "NO PROTOCOL SET", style: const TextStyle(color: Colors.grey, letterSpacing: 2))),
    );
  }

  void _toggleWorkout(String item, bool? done) async {
    setState(() {
      if (done == true) {
        (AppData.todayMacros?["completed_items"] as List).add(item);
      } else {
        (AppData.todayMacros?["completed_items"] as List).remove(item);
      }
    });
    await DbService.updateWorkoutProgress(AppData.userEmail!, item, done ?? false);
  }

  Future<void> _refreshData() async {
    setState(() => _syncing = true);
    // Silent force refresh in background
    await AiService.generatePlan((AppData.userName??"User"), 25, 70, "", forceRegenerate: true);
    await AppData.init();
    if (mounted) setState(() => _syncing = false);
  }

  void _showMealLogger() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1C1C1E).withOpacity(0.8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text("SCAN MEAL", style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF00E5FF))),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "What did you fuel with?",
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL", style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              onPressed: () async {
                final meal = controller.text;
                Navigator.pop(context);
                if (meal.isNotEmpty) _analyzeMeal(meal);
              },
              child: const Text("ANALYZE"),
            )
          ],
        ),
      ),
    );
  }

  void _analyzeMeal(String desc) async {
    setState(() => _syncing = true);
    try {
      final macros = await AiService.parseMeal(desc, AppData.location ?? "Unknown");
      await DbService.updateMacros(AppData.userEmail!, addCalories: macros["calories"], addProtein: macros["protein"], mealName: desc);
      await AppData.init();
    } catch (e) {}
    if (mounted) setState(() => _syncing = false);
  }
}
