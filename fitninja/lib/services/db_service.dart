import 'package:mongo_dart/mongo_dart.dart';
import 'package:intl/intl.dart';

class DbService {
  static const String mongoUrl = String.fromEnvironment('MONGO_URI', defaultValue: '');
  static late Db db;
  static late DbCollection usersCollection;

  static Future<void> connect() async {
    db = await Db.create(mongoUrl);
    await db.open();
    usersCollection = db.collection('users');
    print("Connected to MongoDB directly");
  }

  static Future<bool> performSignup(String name, int age, int weight, String email, String password, String otp) async {
    final existingUser = await usersCollection.findOne({"email": email});
    if (existingUser != null) {
      throw Exception("User already exists");
    }

    await usersCollection.insertOne({
      "email": email,
      "password": password, 
      "name": name,
      "age": age,
      "weight": weight,
      "verified": false,
      "otp": otp,
      "onboardingCompleted": false,
      "dailyStats": {}
    });
    return true;
  }

  static Future<Map<String, dynamic>?> login(String email, String password) async {
    final user = await usersCollection.findOne({"email": email, "password": password});
    if (user != null) {
      if (user["verified"] == false) {
          throw Exception("Account not verified");
      }
      return user;
    }
    throw Exception("Invalid credentials");
  }

  static Future<bool> verifyOtp(String email, String userOtp) async {
    final user = await usersCollection.findOne({"email": email});
    if (user != null && user["otp"] == userOtp) {
      await usersCollection.updateOne(
        where.eq("email", email),
        modify.set("verified", true).set("otp", "")
      );
      return true;
    }
    return false;
  }

  static Future<void> saveOnboarding(String email, String location, String time, List<String> equipment) async {
      await usersCollection.updateOne(
          where.eq("email", email),
          modify.set("location", location)
                .set("workout_time", time)
                .set("equipment", equipment)
                .set("onboardingCompleted", true)
      );
  }

  // MACRO / AI / WORKOUT TRACKING
  static String get _todayStr => DateFormat('yyyy-MM-dd').format(DateTime.now());

  static Future<void> updateMacros(String email, {int? addCalories, int? addProtein, bool incrementWorkout = false, String? mealName}) async {
    final user = await usersCollection.findOne({"email": email});
    if (user == null) return;
    
    Map<String, dynamic> stats = user["dailyStats"] ?? {};
    Map<String, dynamic> todayStats = stats[_todayStr] ?? {
        "calories": 0, 
        "protein": 0, 
        "workouts": 0, 
        "completed_items": [], 
        "meal_log": [],
        "boxing_complete": false,
        "punch_count": 0,
        "avg_speed": 0.0
    };

    if (addCalories != null) todayStats["calories"] += addCalories;
    if (addProtein != null) todayStats["protein"] += addProtein;
    if (incrementWorkout) todayStats["workouts"] += 1;
    if (mealName != null) {
        List mealLog = todayStats["meal_log"] ?? [];
        mealLog.add({"name": mealName, "calories": addCalories ?? 0, "protein": addProtein ?? 0, "time": DateTime.now().toIso8601String()});
        todayStats["meal_log"] = mealLog;
    }

    stats[_todayStr] = todayStats;

    await usersCollection.updateOne(
      where.eq("email", email),
      modify.set("dailyStats", stats)
    );
  }

  static Future<void> updateWorkoutProgress(String email, String itemName, bool completed) async {
    final user = await usersCollection.findOne({"email": email});
    if (user == null) return;

    Map<String, dynamic> stats = user["dailyStats"] ?? {};
    Map<String, dynamic> todayStats = stats[_todayStr] ?? {
        "calories": 0, "protein": 0, "workouts": 0, "completed_items": [], "meal_log": [], "boxing_complete": false
    };

    List completedItems = todayStats["completed_items"] ?? [];
    if (completed) {
      if (!completedItems.contains(itemName)) completedItems.add(itemName);
    } else {
      completedItems.remove(itemName);
    }
    todayStats["completed_items"] = completedItems;
    stats[_todayStr] = todayStats;

    await usersCollection.updateOne(
      where.eq("email", email),
      modify.set("dailyStats", stats)
    );
  }

  static Future<void> completeBoxingSession(String email, int punches, double speed) async {
    final user = await usersCollection.findOne({"email": email});
    if (user == null) return;

    Map<String, dynamic> stats = user["dailyStats"] ?? {};
    Map<String, dynamic> todayStats = stats[_todayStr] ?? {
        "calories": 0, "protein": 0, "workouts": 0, "completed_items": [], "meal_log": [], "boxing_complete": false
    };

    todayStats["boxing_complete"] = true;
    todayStats["punch_count"] = punches;
    todayStats["avg_speed"] = speed;
    stats[_todayStr] = todayStats;

    await usersCollection.updateOne(
      where.eq("email", email),
      modify.set("dailyStats", stats)
    );
  }

  static Future<Map<String, dynamic>> getTodayMacros(String email) async {
     final user = await usersCollection.findOne({"email": email});
     if (user == null) return {"calories": 0, "protein": 0, "workouts": 0, "completed_items": [], "meal_log": [], "boxing_complete": false};
     
     Map<String, dynamic> stats = user["dailyStats"] ?? {};
     return stats[_todayStr] ?? {"calories": 0, "protein": 0, "workouts": 0, "completed_items": [], "meal_log": [], "boxing_complete": false};
  }
}
