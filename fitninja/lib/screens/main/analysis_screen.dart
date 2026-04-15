import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/app_data.dart';
import '../../services/db_service.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});
  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  List<Map<String, dynamic>> _weeklyData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    // Generate last 7 days keys
    List<String> last7Days = [];
    for (int i = 6; i >= 0; i--) {
      last7Days.add(DateTime.now().subtract(Duration(days: i)).toIso8601String().split('T')[0]);
    }

    // Mock/Fetch data aggregation
    // In a real app, you'd fetch the user doc and parse dailyStats
    // For this build, we'll simulate the trend if DB is empty
    setState(() {
       _weeklyData = last7Days.map((date) => {
         "date": date,
         "punches": (100 + (date.hashCode % 300)), // dynamic mock
         "calories": (1500 + (date.hashCode % 500)),
         "protein": (80 + (date.hashCode % 40)),
       }).toList();
       _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0F0F), Color(0xFF1A1A1A)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("TACTICAL ANALYSIS", style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28)).animate().fadeIn().slideX(),
                const SizedBox(height: 8),
                Text("WEEKLY PERFORMANCE OVERVIEW", style: TextStyle(color: Colors.white.withOpacity(0.5), letterSpacing: 1.5, fontSize: 10)),
                const SizedBox(height: 32),
                
                _buildMainStatCard(),
                const SizedBox(height: 24),
                
                const Text("PUNCH INTENSITY TREND", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 16),
                _buildPunchChart(),
                
                const SizedBox(height: 32),
                const Text("MACRO CONSISTENCY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 16),
                _buildMacroChart(),
                
                const SizedBox(height: 32),
                _buildConsistencyGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainStatCard() {
    int totalPunches = _weeklyData.fold(0, (sum, item) => sum + (item['punches'] as int));
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [BoxShadow(color: const Color(0xFF00E5FF).withOpacity(0.1), blurRadius: 20, spreadRadius: -5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("WEEKLY STRIKES", style: TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 4),
              Text(totalPunches.toString(), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF00E5FF))),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
            child: const Icon(Icons.show_chart_rounded, color: Color(0xFF00E5FF)),
          )
        ],
      ),
    ).animate().scale(delay: 200.ms);
  }

  Widget _buildPunchChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(24)),
      child: BarChart(
        BarChartData(
          barGroups: _weeklyData.asMap().entries.map((e) => BarChartGroupData(x: e.key, barRods: [
            BarChartRodData(toY: e.value['punches'].toDouble(), color: const Color(0xFF00E5FF), width: 12, borderRadius: BorderRadius.circular(4)),
          ])).toList(),
          titlesData: const FlTitlesData(show: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildMacroChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(24)),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: _weeklyData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value['calories'].toDouble() / 10)).toList(),
              isCurved: true, color: Colors.orangeAccent, barWidth: 3, dotData: const FlDotData(show: false),
            )
          ],
          titlesData: const FlTitlesData(show: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildConsistencyGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildMiniStat("AVG POWER", "8.2", Icons.flash_on)),
            const SizedBox(width: 16),
            Expanded(child: _buildMiniStat("ACCURACY", "94%", Icons.track_changes)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("PROTEIN TARGET", style: TextStyle(color: Colors.white54, fontSize: 10)),
                  Text("${AppData.proteinGoal}g Daily", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00E5FF))),
                ],
              ),
              Text("Based on ${AppData.userWeight}kg Weight", style: const TextStyle(color: Colors.white24, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(String label, String val, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white24, size: 20),
          const SizedBox(height: 12),
          Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }
}
