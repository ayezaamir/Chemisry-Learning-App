import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Attempt {
  final String date;
  final int score;
  final int total;

  Attempt({required this.date, required this.score, required this.total});

  // Convert Attempt object to JSON
  Map<String, dynamic> toJson() => {
    'date': date,
    'score': score,
    'total': total,
  };

  // Create Attempt object from JSON
  factory Attempt.fromJson(Map<String, dynamic> json) {
    return Attempt(
      date: json['date'],
      score: json['score'],
      total: json['total'],
    );
  }
}

class AttemptStorage {
  // Save an attempt under a username-specific key
  static Future<void> saveAttempt(String userName, Attempt attempt) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'quiz_attempts_$userName'; // Key unique to each user
    List<String> attempts = prefs.getStringList(key) ?? [];

    attempts.add(jsonEncode(attempt.toJson()));
    await prefs.setStringList(key, attempts);
  }

  // Retrieve all attempts for a specific user
  static Future<List<Attempt>> getAttempts(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'quiz_attempts_$userName';
    List<String> attempts = prefs.getStringList(key) ?? [];

    return attempts.map((json) => Attempt.fromJson(jsonDecode(json))).toList();
  }
}
