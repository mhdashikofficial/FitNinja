import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'ai_service.dart';
import 'db_service.dart';

class AppData {
  static final AppData _instance = AppData._internal();
  factory AppData() => _instance;
  AppData._internal();

  static String? userEmail;
  static String? userName;
  static int userWeight = 70;
  static int proteinGoal = 140;
  static bool onboardingCompleted = false;
  static Map<String, dynamic>? currentPlan;
  static Map<String, dynamic>? todayMacros;
  static String? location;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('userEmail');
    userName = prefs.getString('userName');
    userWeight = prefs.getInt('userWeight') ?? 70;
    proteinGoal = (userWeight * 2.0).toInt(); // Elite Athlete standard: 2g per Kg
    onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

    if (userEmail != null) {
      // 1. Sync current plan from local cache
      currentPlan = await AiService.getCachedTodayPlan();
      
      // FIX: Proactively generate plan if missing
      if (currentPlan == null) {
        final age = prefs.getInt('userAge') ?? 25;
        final weight = prefs.getInt('userWeight') ?? 70;
        
        // Fetch user detail for equipment
        final user = await DbService.usersCollection.findOne({"email": userEmail});
        String eq = "";
        if (user != null) {
          eq = (user["equipment"] as List?)?.join(", ") ?? "";
          location = user["location"] ?? "Unknown";
          userName = user["name"] ?? userName;
        }

        // Generate now (blocks for a few seconds during splash)
        currentPlan = await AiService.generatePlan(userName ?? "User", age, weight, eq);
      } else {
         // Even if plan exists, sync other details in background
         final user = await DbService.usersCollection.findOne({"email": userEmail});
         if (user != null) {
           location = user["location"] ?? "Unknown";
           userName = user["name"] ?? userName;
         }
      }

      // 2. Sync macros from DB
      try {
        todayMacros = await DbService.getTodayMacros(userEmail!);
      } catch (e) {
        todayMacros = {"calories": 0, "protein": 0, "completed_items": [], "boxing_complete": false};
      }
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    userEmail = null;
    userName = null;
    currentPlan = null;
    todayMacros = null;
  }
}
