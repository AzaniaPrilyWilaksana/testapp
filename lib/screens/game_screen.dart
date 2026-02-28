import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trivia_models.dart';
import '../providers/game_provider.dart';
import '../widgets/cosmic_background.dart';
import '../widgets/timer_ring.dart';
import 'results_screen.dart';
import 'menu_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    // Navigate to results when game completes
    if (provider.gameState == GameState.complete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ResultsScreen()),
        );
      });
    }

    if (provider.gameState == GameState.idle) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MenuScreen()),
          (_) => false,
        );
      });
    }

    final question = provider.currentQuestion;
    if (question == null) return const SizedBox.shrink();

    return CosmicBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              _GameHeader(provider: provider),
              _ProgressBar(provider: provider),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _QuestionCard(provider: provider, question: question),
                      const SizedBox(height: 16),
                      if (provider.gameState == GameState.answerRevealed)
                        _ExplanationBubble(question: question),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              _BottomActionBar(provider: provider),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _GameHeader extends StatelessWidget {
  final GameProvider provider;
  const _GameHeader({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          // Quit
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white54),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: const Color(0xFF1A0533),
                title: const Text('Quit Game?', style: TextStyle(color: Colors.white)),
                content: const Text(
                  'Your progress will be lost.',
                  style: TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Continue', style: TextStyle(color: Colors.white70)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      provider.quitGame();
                    },
                    child: const Text('Quit', style: TextStyle(color: Color(0xFFE57373))),
                  ),
                ],
              ),
            ),
          ),
          // Question counter
          Expanded(
            child: Center(
              child: Text(
                'Q ${provider.currentQuestionNumber} / ${provider.totalQuestions}',
                style: const TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ),
          ),
          // Score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⭐', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  '${provider.score}',
                  style: const TextStyle(
                    color: Color(0xFFFFD54F),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Progress Bar ─────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final GameProvider provider;
  const _ProgressBar({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: provider.progress,
          backgroundColor: Colors.white12,
          valueColor: const AlwaysStoppedAnimation(Color(0xFF7C4DFF)),
          minHeight: 4,
        ),
      ),
    );
  }
}

// ─── Question Card ────────────────────────────────────────────────────────────

class _QuestionCard extends StatelessWidget {
  final GameProvider provider;
  final TriviaQuestion question;

  const _QuestionCard({required this.provider, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          // Category + difficulty badges + timer
          Row(
            children: [
              _Badge(
                label: '${question.category.emoji} ${question.category.displayName}',
                color: question.category.color,
              ),
              const SizedBox(width: 8),
              _Badge(
                label: question.difficulty.displayName,
                color: question.difficulty.color,
              ),
              const Spacer(),
              if (provider.gameState == GameState.playing)
                TimerRing(
                  timeRemaining: provider.timeRemaining,
                  totalTime: question.difficulty.timeLimit.toDouble(),
                  size: 60,
                ),
            ],
          ),
          const SizedBox(height: 20),
          // Question text
          Text(
            question.question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Answer options
          ...List.generate(question.options.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AnswerOption(
                index: i,
                label: question.options[i],
                provider: provider,
                question: question,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ─── Answer Option ────────────────────────────────────────────────────────────

class _AnswerOption extends StatelessWidget {
  final int index;
  final String label;
  final GameProvider provider;
  final TriviaQuestion question;

  const _AnswerOption({
    required this.index,
    required this.label,
    required this.provider,
    required this.question,
  });

  Color _bgColor() {
    if (provider.gameState == GameState.playing) return Colors.white.withOpacity(0.07);
    if (index == question.correctIndex) return const Color(0xFF81C784).withOpacity(0.2);
    if (index == provider.selectedAnswerIndex) return const Color(0xFFE57373).withOpacity(0.2);
    return Colors.white.withOpacity(0.04);
  }

  Color _borderColor() {
    if (provider.gameState == GameState.playing) return Colors.white12;
    if (index == question.correctIndex) return const Color(0xFF81C784);
    if (index == provider.selectedAnswerIndex) return const Color(0xFFE57373);
    return Colors.white12;
  }

  String? _trailingIcon() {
    if (provider.gameState != GameState.answerRevealed) return null;
    if (index == question.correctIndex) return '✓';
    if (index == provider.selectedAnswerIndex) return '✗';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const letters = ['A', 'B', 'C', 'D'];
    final canTap = provider.gameState == GameState.playing;

    return GestureDetector(
      onTap: canTap ? () => provider.submitAnswer(index) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _bgColor(),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _borderColor(), width: 1.4),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                letters[index],
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            if (_trailingIcon() != null)
              Text(_trailingIcon()!, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

// ─── Explanation Bubble ───────────────────────────────────────────────────────

class _ExplanationBubble extends StatelessWidget {
  final TriviaQuestion question;
  const _ExplanationBubble({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF7C4DFF).withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF7C4DFF).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              question.explanation,
              style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Action Bar ────────────────────────────────────────────────────────

class _BottomActionBar extends StatelessWidget {
  final GameProvider provider;
  const _BottomActionBar({required this.provider});

  @override
  Widget build(BuildContext context) {
    final isRevealed = provider.gameState == GameState.answerRevealed;
    final isPlaying = provider.gameState == GameState.playing;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Row(
        children: [
          if (isPlaying)
            Expanded(
              child: OutlinedButton(
                onPressed: provider.skipQuestion,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Colors.white54,
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Skip', style: TextStyle(fontSize: 16)),
              ),
            ),
          if (isPlaying) const SizedBox(width: 12),
          if (isRevealed)
            Expanded(
              child: ElevatedButton(
                onPressed: provider.nextQuestion,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF7C4DFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text(
                  provider.isLastQuestion ? 'See Results' : 'Next Question',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
