import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiService {
  static const String _apiUrl = String.fromEnvironment('NVIDIA_API_URL', defaultValue: 'https://integrate.api.nvidia.com/v1/chat/completions');
  static const String _apiKey = String.fromEnvironment('NVIDIA_API_KEY', defaultValue: '');
  static const String _model = "meta/llama-3.1-70b-instruct"; 
  static String get _todayStr => DateFormat('yyyy-MM-dd').format(DateTime.now());
  static String get _dayOfWeek => DateFormat('EEEE').format(DateTime.now());

  static Future<Map<String, dynamic>?> getCachedTodayPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedDate = prefs.getString('ai_plan_date');
    final cachedData = prefs.getString('ai_plan_data');

    if (cachedDate == _todayStr && cachedData != null) {
      try {
        return jsonDecode(cachedData);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<Map<String, dynamic>> generatePlan(String name, int age, int weight, String equipment, {bool forceRegenerate = false}) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (!forceRegenerate) {
        final cached = await getCachedTodayPlan();
        if (cached != null) return cached;
    }

    String focusArea = "";
    switch (_dayOfWeek) {
      case "Monday": focusArea = "Chest Day"; break;
      case "Tuesday": focusArea = "Back Day"; break;
      case "Wednesday": focusArea = "Abs Day"; break;
      case "Thursday": focusArea = "Shoulders Day"; break;
      case "Friday": focusArea = "Arms Day"; break;
      case "Saturday": focusArea = "Legs Day"; break;
      case "Sunday": focusArea = "Rest & Recovery"; break;
    }

    final prompt = '''
Act as an Elite Physical Trainer and Boxing Head Coach.
Name: $name, Age: $age, Weight: $weight kg.
Equipment: ${equipment.isEmpty ? 'Strictly Bodyweight' : equipment}.
Day: $_dayOfWeek ($focusArea).

STRICT OUTPUT REQUIREMENTS:
1. Return ONLY valid JSON.
2. WORKOUT PLAN: Provide 6-8 HIGHLY SPECIFIC exercises tailored to the Focus Area and Equipment. NO generic names like "Exercise 1". 
   - Each item must include: sets, reps, and a technical Mastery Tip.
3. BOXING STRATEGY: Provide a detailed 10-15 minute session.
   - For each round, give a specific drill AND a "Tactical Focus" (e.g. "Keep lead hand high", "Counter the slip").
4. FOOD PLAN: Suggest high-performance meals for today.

JSON SCHEMA:
{
  "focus": "$focusArea",
  "is_rest_day": ${_dayOfWeek == "Sunday"},
  "food_plan": "Protein-heavy menu focusing on recovery",
  "workout_plan": [
     {"item": "Specific Exercise Name (Sets x Reps)", "instruction": "Technical form cue for mastery"},
     ... (6-8 items)
  ],
  "boxing_drills": [
     {"round": 1, "drill": "Detailed Combination", "details": "Specific tactical coaching for this round"},
     ...
  ]
}
''';

    try {
      final response = await _callNvidia(prompt);
      final Map<String, dynamic> planJson = _extractJson(response);
      
      await prefs.setString('ai_plan_date', _todayStr);
      await prefs.setString('ai_plan_data', jsonEncode(planJson));
      return planJson;
    } catch (e) {
      print("AI Error: $e");
      return _getFallbackPlan(focusArea);
    }
  }

  static Future<Map<String, dynamic>> parseMeal(String mealDescription, String location) async {
    final prompt = '''
Acts as a nutrition expert for a user in $location.
Analyze: "$mealDescription". Estimate calories and protein.
JSON ONLY: {"calories": int, "protein": int}
''';
    try {
      final response = await _callNvidia(prompt);
      return _extractJson(response);
    } catch (e) {
      return {"calories": 350, "protein": 20};
    }
  }

  static Future<String> _callNvidia(String prompt) async {
    final headers = {
      "Authorization": "Bearer $_apiKey",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    final payload = {
      "model": _model,
      "messages": [{"role": "user", "content": prompt}],
      "max_tokens": 2000,
      "temperature": 0.6,
      "stream": false
    };

    final response = await http.post(
      Uri.parse(_apiUrl), 
      headers: headers, 
      body: jsonEncode(payload)
    ).timeout(const Duration(seconds: 50));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return decoded['choices'][0]['message']['content'];
    } else {
      throw Exception("HTTP ${response.statusCode}");
    }
  }

  static Map<String, dynamic> _extractJson(String content) {
    try {
      final regex = RegExp(r'\{[\s\S]*\}');
      final match = regex.firstMatch(content);
      if (match != null) {
        return jsonDecode(match.group(0)!);
      }
    } catch (e) {}
    throw Exception("Invalid format");
  }

  static Map<String, dynamic> _getFallbackPlan(String focus) {
    // Focus-specific hardcoded protocols
    final Map<String, List<Map<String, String>>> protocols = {
      "Chest Day": [
        {"item": "Pushups (4 Sets x Max)", "instruction": "Elbows at 45 degrees, chest to floor"},
        {"item": "Dumbbell Press (4 x 10)", "instruction": "Controlled eccentric, explosive push"},
        {"item": "Diamond Pushups (3 x 15)", "instruction": "Focus on inner chest and triceps"},
        {"item": "Chest Dips (3 x 10)", "instruction": "Lean forward to engage pectorals"},
        {"item": "Plank Shoulder Taps (3 x 20)", "instruction": "Core stability while fatigued"},
        {"item": "Decline Pushups (3 x 12)", "instruction": "Feet elevated, focus on upper chest"}
      ],
      "Back Day": [
        {"item": "Pullups (4 x 8)", "instruction": "Full extension, chin over bar"},
        {"item": "Dumbbell Rows (4 x 12)", "instruction": "Pull to hip, squeeze lat"},
        {"item": "Supermans (3 x 15)", "instruction": "Hold at top for 2 seconds"},
        {"item": "Reverse Flyes (3 x 12)", "instruction": "Focus on rear delts"},
        {"item": "Lat Pulldowns (4 x 12)", "instruction": "Pull with elbows, not hands"},
        {"item": "Bird-Dog (3 x 10/side)", "instruction": "Keep spine neutral"}
      ],
      "Abs Day": [
        {"item": "Leg Raises (4 x 15)", "instruction": "Keep lower back pressed to floor"},
        {"item": "Russian Twists (3 x 30)", "instruction": "Touch floor on each side, legs elevated"},
        {"item": "Plank (3 x 60s)", "instruction": "Body in straight line, squeeze glutes"},
        {"item": "Bicycle Crunches (3 x 20)", "instruction": "Opposite elbow to opposite knee"},
        {"item": "Mountain Climbers (3 x 40)", "instruction": "Keep hips low, drive knees in"}
      ],
      "Shoulders Day": [
        {"item": "Overhead Press (4 x 10)", "instruction": "Press straight up, don't arch back"},
        {"item": "Lateral Raises (4 x 12)", "instruction": "Lead with elbows, slight bend"},
        {"item": "Front Raises (3 x 12)", "instruction": "Control the descent, no swinging"},
        {"item": "Pike Pushups (3 x 8)", "instruction": "Hips high, head between hands"},
        {"item": "Face Pulls (3 x 15)", "instruction": "Pull towards face, squeeze rear delts"}
      ],
      "Arms Day": [
        {"item": "Bicep Curls (4 x 12)", "instruction": "Full range of motion, no body swing"},
        {"item": "Tricep Dips (4 x 12)", "instruction": "Keep elbows tucked to sides"},
        {"item": "Hammer Curls (3 x 12)", "instruction": "Neutral grip, squeeze at top"},
        {"item": "Skull Crushers (3 x 10)", "instruction": "Keep upper arms vertical"},
        {"item": "Concentration Curls (3 x 12)", "instruction": "Isolate the bicep against thigh"}
      ],
      "Legs Day": [
        {"item": "Goblet Squats (4 x 12)", "instruction": "Hips back, chest up, break parallel"},
        {"item": "Lunges (4 x 10/side)", "instruction": "Keep torso upright, knee doesn't hit floor"},
        {"item": "Calf Raises (4 x 20)", "instruction": "Full extension of the calf muscle"},
        {"item": "Glute Bridges (3 x 15)", "instruction": "Squeeze glutes at peak height"},
        {"item": "Wall Sit (3 x 45s)", "instruction": "90 degree angle at knees and hips"}
      ],
      "Rest & Recovery": [
        {"item": "Dynamic Stretching (10 min)", "instruction": "Focus on hip and shoulder mobility"},
        {"item": "Foam Rolling (5 min)", "instruction": "Roll out sore muscles gently"},
        {"item": "Deep Breathing (5 min)", "instruction": "Focus on oxygen intake and mental calm"}
      ]
    };

    final focusProtocol = protocols[focus] ?? protocols["Chest Day"]!;

    return {
      "focus": focus,
      "is_rest_day": focus == "Rest & Recovery",
      "food_plan": "Balanced macros with emphasis on lean protein.",
      "workout_plan": focusProtocol,
      "boxing_drills": [
        {"round": 1, "drill": "Jab-Cross-Hook-Slip", "details": "Focus on head movement after the hook"},
        {"round": 2, "drill": "1-2-5-2 (Jab Cross Lead-Uppercut Cross)", "details": "Speed over power, keep chin tucked"}
      ]
    };
  }
}
