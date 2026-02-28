import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trivia_models.dart';
import '../providers/game_provider.dart';
import '../widgets/cosmic_background.dart';
import '../widgets/confetti_widget.dart';
import 'category_select_screen.dart';
import 'menu_screen.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _showReview = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final rank = provider.rank;

    return CosmicBackground(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Rank badge
                    _RankBadge(rank: rank),
                    const SizedBox(height: 28),

                    // New high score
                    if (provider.isNewHighScore) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFFFFD700).withOpacity(0.5)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('🏆', style: TextStyle(fontSize: 18)),
                            SizedBox(width: 8),
                            Text(
                              'New Personal Best!',
                              style: TextStyle(
                                color: Color(0xFFFFD700),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Stats row
                    _StatsRow(provider: provider),
                    const SizedBox(height: 28),

                    // Answer review toggle
                    GestureDetector(
                      onTap: () => setState(() => _showReview = !_showReview),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          children: [
                            const Text('📋',
                                style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Review Answers',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Icon(
                              _showReview
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.white38,
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (_showReview) ...[
                      const SizedBox(height: 12),
                      ...provider.answerRecords.map(
                        (r) => _AnswerReviewRow(record: r),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Buttons
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.resetToMenu();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CategorySelectScreen()),
                            (_) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF7C4DFF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Play Again',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          provider.resetToMenu();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MenuScreen()),
                            (_) => false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: Colors.white70,
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text(
                          'Main Menu',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          const ConfettiWidget(),
        ],
      ),
    );
  }
}

// ─── Rank Badge ───────────────────────────────────────────────────────────────

class _RankBadge extends StatelessWidget {
  final ScoreRank rank;
  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(rank.emoji, style: const TextStyle(fontSize: 72)),
        const SizedBox(height: 12),
        Text(
          rank.title,
          style: TextStyle(
            color: rank.color,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          rank.subtitle,
          style: const TextStyle(color: Colors.white54, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final GameProvider provider;
  const _StatsRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatItem(
          emoji: '⭐',
          label: 'Score',
          value: '${provider.score}',
          color: const Color(0xFFFFD54F),
        ),
        _StatItem(
          emoji: '✓',
          label: 'Correct',
          value: '${provider.correctCount}/${provider.totalQuestions}',
          color: const Color(0xFF81C784),
        ),
        _StatItem(
          emoji: '🎯',
          label: 'Accuracy',
          value: '${(provider.accuracy * 100).round()}%',
          color: const Color(0xFF64B5F6),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.emoji,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Answer Review Row ────────────────────────────────────────────────────────

class _AnswerReviewRow extends StatelessWidget {
  final AnswerRecord record;
  const _AnswerReviewRow({required this.record});

  @override
  Widget build(BuildContext context) {
    final correct = record.isCorrect;
    final skipped = record.selectedIndex == null;

    Color borderColor = skipped
        ? Colors.white24
        : correct
            ? const Color(0xFF81C784)
            : const Color(0xFFE57373);

    String status = skipped ? '⏭' : correct ? '✓' : '✗';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(status, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  record.question.question,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '+${record.pointsEarned}',
                style: TextStyle(
                  color: record.pointsEarned > 0
                      ? const Color(0xFFFFD54F)
                      : Colors.white30,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          if (!correct) ...[
            const SizedBox(height: 6),
            Text(
              'Correct: ${record.question.options[record.question.correctIndex]}',
              style: const TextStyle(
                color: Color(0xFF81C784),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
