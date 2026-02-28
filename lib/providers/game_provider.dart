import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trivia_models.dart';
import '../data/trivia_data.dart';

enum GameState { idle, playing, answerRevealed, complete }

class GameProvider extends ChangeNotifier {
  // ─── Config ─────────────────────────────────────────────────────────────────
  TriviaCategory? selectedCategory;
  Difficulty selectedDifficulty = Difficulty.beginner;
  int questionCount = 10;

  // ─── Game State ──────────────────────────────────────────────────────────────
  GameState gameState = GameState.idle;
  List<TriviaQuestion> _questions = [];
  int _currentIndex = 0;
  int score = 0;
  int highScore = 0;
  bool isNewHighScore = false;

  double _timeRemaining = 20;
  Timer? _timer;

  int? selectedAnswerIndex;
  List<AnswerRecord> answerRecords = [];

  // ─── Getters ─────────────────────────────────────────────────────────────────
  TriviaQuestion? get currentQuestion =>
      _questions.isNotEmpty && _currentIndex < _questions.length
          ? _questions[_currentIndex]
          : null;

  double get timeRemaining => _timeRemaining;

  int get currentQuestionNumber => _currentIndex + 1;
  int get totalQuestions => _questions.length;

  double get progress =>
      _questions.isEmpty ? 0 : _currentIndex / _questions.length;

  bool get isLastQuestion => _currentIndex >= _questions.length - 1;

  // ─── Init ─────────────────────────────────────────────────────────────────────
  GameProvider() {
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;
    notifyListeners();
  }

  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', highScore);
  }

  // ─── Game Control ─────────────────────────────────────────────────────────────
  void startGame() {
    _questions = TriviaData.getQuestions(
      category: selectedCategory,
      difficulty: selectedDifficulty,
      count: questionCount,
    );
    _currentIndex = 0;
    score = 0;
    answerRecords = [];
    isNewHighScore = false;
    gameState = GameState.playing;
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeRemaining = selectedDifficulty.timeLimit.toDouble();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _timeRemaining -= 0.1;
      if (_timeRemaining <= 0) {
        _timeRemaining = 0;
        _onTimerExpired();
      }
      notifyListeners();
    });
  }

  void _onTimerExpired() {
    _timer?.cancel();
    final q = currentQuestion!;
    answerRecords.add(AnswerRecord(
      question: q,
      selectedIndex: null,
      isCorrect: false,
      pointsEarned: 0,
      timeUsed: q.difficulty.timeLimit.toDouble(),
    ));
    selectedAnswerIndex = null;
    gameState = GameState.answerRevealed;
    notifyListeners();
  }

  void submitAnswer(int index) {
    if (gameState != GameState.playing) return;
    _timer?.cancel();

    final q = currentQuestion!;
    final timeLimit = q.difficulty.timeLimit.toDouble();
    final timeUsed = timeLimit - _timeRemaining;
    final isCorrect = index == q.correctIndex;

    int points = 0;
    if (isCorrect) {
      final ratio = _timeRemaining / timeLimit;
      final multiplier = 0.5 + (ratio * 0.5); // 0.5x → 1.0x
      points = (q.difficulty.basePoints * multiplier).round();
      score += points;
    }

    answerRecords.add(AnswerRecord(
      question: q,
      selectedIndex: index,
      isCorrect: isCorrect,
      pointsEarned: points,
      timeUsed: timeUsed,
    ));

    selectedAnswerIndex = index;
    gameState = GameState.answerRevealed;
    notifyListeners();
  }

  void skipQuestion() {
    if (gameState != GameState.playing) return;
    _timer?.cancel();

    final q = currentQuestion!;
    answerRecords.add(AnswerRecord(
      question: q,
      selectedIndex: null,
      isCorrect: false,
      pointsEarned: 0,
      timeUsed: q.difficulty.timeLimit - _timeRemaining,
    ));

    selectedAnswerIndex = null;
    gameState = GameState.answerRevealed;
    notifyListeners();
  }

  void nextQuestion() {
    if (isLastQuestion) {
      _endGame();
      return;
    }
    _currentIndex++;
    selectedAnswerIndex = null;
    gameState = GameState.playing;
    _startTimer();
    notifyListeners();
  }

  void _endGame() {
    _timer?.cancel();
    gameState = GameState.complete;
    if (score > highScore) {
      highScore = score;
      isNewHighScore = true;
      _saveHighScore();
    }
    notifyListeners();
  }

  void quitGame() {
    _timer?.cancel();
    gameState = GameState.idle;
    notifyListeners();
  }

  void resetToMenu() {
    _timer?.cancel();
    gameState = GameState.idle;
    selectedAnswerIndex = null;
    _questions = [];
    _currentIndex = 0;
    score = 0;
    notifyListeners();
  }

  // ─── Stats ────────────────────────────────────────────────────────────────────
  int get correctCount => answerRecords.where((r) => r.isCorrect).length;

  double get accuracy =>
      answerRecords.isEmpty ? 0 : correctCount / answerRecords.length;

  ScoreRank get rank {
    final maxPossible = _questions.fold<int>(
      0,
      (sum, q) => sum + q.difficulty.basePoints,
    );
    final pct = maxPossible == 0 ? 0.0 : score / maxPossible;
    return ScoreRank.fromPercentage(pct);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
