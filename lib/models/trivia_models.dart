import 'package:flutter/material.dart';

// ─── Category ────────────────────────────────────────────────────────────────

enum TriviaCategory {
  zodiac,
  planets,
  tarot,
  chakras,
  crystals,
  numerology,
  moonPhases,
  mythology,
}

extension TriviaCategoryExt on TriviaCategory {
  String get displayName {
    switch (this) {
      case TriviaCategory.zodiac:      return 'Zodiac Signs';
      case TriviaCategory.planets:     return 'Planets & Astrology';
      case TriviaCategory.tarot:       return 'Tarot';
      case TriviaCategory.chakras:     return 'Chakras';
      case TriviaCategory.crystals:    return 'Crystals & Stones';
      case TriviaCategory.numerology:  return 'Numerology';
      case TriviaCategory.moonPhases:  return 'Moon Phases';
      case TriviaCategory.mythology:   return 'Spiritual Mythology';
    }
  }

  String get emoji {
    switch (this) {
      case TriviaCategory.zodiac:      return '♈';
      case TriviaCategory.planets:     return '🪐';
      case TriviaCategory.tarot:       return '🃏';
      case TriviaCategory.chakras:     return '🌀';
      case TriviaCategory.crystals:    return '💎';
      case TriviaCategory.numerology:  return '🔢';
      case TriviaCategory.moonPhases:  return '🌙';
      case TriviaCategory.mythology:   return '✨';
    }
  }

  Color get color {
    switch (this) {
      case TriviaCategory.zodiac:      return const Color(0xFFE57373);
      case TriviaCategory.planets:     return const Color(0xFF64B5F6);
      case TriviaCategory.tarot:       return const Color(0xFFBA68C8);
      case TriviaCategory.chakras:     return const Color(0xFF81C784);
      case TriviaCategory.crystals:    return const Color(0xFF4DD0E1);
      case TriviaCategory.numerology:  return const Color(0xFFFFD54F);
      case TriviaCategory.moonPhases:  return const Color(0xFFCE93D8);
      case TriviaCategory.mythology:   return const Color(0xFFF06292);
    }
  }
}

// ─── Difficulty ──────────────────────────────────────────────────────────────

enum Difficulty { beginner, intermediate, advanced }

extension DifficultyExt on Difficulty {
  String get displayName {
    switch (this) {
      case Difficulty.beginner:     return 'Beginner';
      case Difficulty.intermediate: return 'Intermediate';
      case Difficulty.advanced:     return 'Advanced';
    }
  }

  int get basePoints {
    switch (this) {
      case Difficulty.beginner:     return 10;
      case Difficulty.intermediate: return 20;
      case Difficulty.advanced:     return 30;
    }
  }

  int get timeLimit {
    switch (this) {
      case Difficulty.beginner:     return 20;
      case Difficulty.intermediate: return 15;
      case Difficulty.advanced:     return 10;
    }
  }

  Color get color {
    switch (this) {
      case Difficulty.beginner:     return const Color(0xFF81C784);
      case Difficulty.intermediate: return const Color(0xFFFFD54F);
      case Difficulty.advanced:     return const Color(0xFFE57373);
    }
  }
}

// ─── Question ─────────────────────────────────────────────────────────────────

class TriviaQuestion {
  final String id;
  final TriviaCategory category;
  final Difficulty difficulty;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const TriviaQuestion({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

// ─── Answer Record ────────────────────────────────────────────────────────────

class AnswerRecord {
  final TriviaQuestion question;
  final int? selectedIndex;   // null = skipped / timed-out
  final bool isCorrect;
  final int pointsEarned;
  final double timeUsed;

  const AnswerRecord({
    required this.question,
    required this.selectedIndex,
    required this.isCorrect,
    required this.pointsEarned,
    required this.timeUsed,
  });
}

// ─── Score Rank ───────────────────────────────────────────────────────────────

class ScoreRank {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;

  const ScoreRank({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  static ScoreRank fromPercentage(double pct) {
    if (pct >= 0.9) {
      return const ScoreRank(
        emoji: '🌟',
        title: 'Cosmic Oracle',
        subtitle: 'You have mastered the cosmic arts!',
        color: Color(0xFFFFD700),
      );
    } else if (pct >= 0.75) {
      return const ScoreRank(
        emoji: '🔮',
        title: 'Astral Sage',
        subtitle: 'Your cosmic wisdom is vast.',
        color: Color(0xFFBA68C8),
      );
    } else if (pct >= 0.6) {
      return const ScoreRank(
        emoji: '⭐',
        title: 'Stargazer',
        subtitle: 'You read the stars with skill.',
        color: Color(0xFF64B5F6),
      );
    } else if (pct >= 0.45) {
      return const ScoreRank(
        emoji: '🌙',
        title: 'Moon Seeker',
        subtitle: 'You\'re finding your cosmic path.',
        color: Color(0xFFCE93D8),
      );
    } else if (pct >= 0.3) {
      return const ScoreRank(
        emoji: '🌱',
        title: 'Cosmic Apprentice',
        subtitle: 'The universe has much to teach you.',
        color: Color(0xFF81C784),
      );
    } else {
      return const ScoreRank(
        emoji: '🌌',
        title: 'Cosmic Novice',
        subtitle: 'Every expert was once a beginner.',
        color: Color(0xFF90A4AE),
      );
    }
  }
}
