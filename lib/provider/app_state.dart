import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quiz.dart';
import '../models/question.dart';

class AppState extends ChangeNotifier {
  static const _kQuizzesKey = 'quizzes_v1';
  static const _kThemeModeKey = 'theme_mode_v1';

  final List<Quiz> _quizzes = [];
  ThemeMode _themeMode = ThemeMode.system;

  List<Quiz> get quizzes => List.unmodifiable(_quizzes);
  ThemeMode get themeMode => _themeMode;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kQuizzesKey);
    if (raw != null) {
      try {
        final list = json.decode(raw) as List<dynamic>;
        _quizzes.clear();
        _quizzes.addAll(list.map((e) => Quiz.fromJson(Map<String, dynamic>.from(e as Map))));
        notifyListeners();
      } catch (e) {
        if (kDebugMode) print('Failed to decode quizzes: $e');
      }
    }

    // Load theme mode
    final themeIndex = prefs.getInt(_kThemeModeKey);
    if (themeIndex != null && themeIndex >= 0 && themeIndex < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[themeIndex];
    }

    // Seed demo data if empty
    if (_quizzes.isEmpty) {
      _seedDemo();
      await _save();
      notifyListeners();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = json.encode(_quizzes.map((q) => q.toJson()).toList());
    await prefs.setString(_kQuizzesKey, raw);
  }

  Future<void> addQuiz(String title, List<Question> questions) async {
    final quiz = Quiz.create(title: title, questions: questions);
    _quizzes.add(quiz);
    await _save();
    notifyListeners();
  }

  Quiz? getById(String id) {
    try {
      return _quizzes.firstWhere((q) => q.id == id);
    } catch (_) {
      return null;
    }
  }

  // For test or quick clearing
  Future<void> clearAll() async {
    _quizzes.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kQuizzesKey);
    notifyListeners();
  }

  void _seedDemo() {
    final demo = Quiz(
      id: 'QUIZ001',
      title: 'General Knowledge Demo',
      questions: [
        Question(
          text: 'Ibu kota Indonesia adalah?',
          options: ['Bandung', 'Jakarta', 'Surabaya', 'Medan'],
          correctIndex: 1,
        ),
        Question(
          text: 'Hasil 2 + 2 × 3 = ?',
          options: ['12', '8', '10', '6'],
          correctIndex: 1,
        ),
        Question(
          text: 'Bahasa pemrograman untuk Flutter?',
          options: ['Kotlin', 'Swift', 'Dart', 'JavaScript'],
          correctIndex: 2,
        ),
      ],
    );
    _quizzes.add(demo);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kThemeModeKey, mode.index);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }
}
