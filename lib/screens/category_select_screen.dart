import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trivia_models.dart';
import '../providers/game_provider.dart';
import '../widgets/cosmic_background.dart';
import 'game_screen.dart';

class CategorySelectScreen extends StatelessWidget {
  const CategorySelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CosmicBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          title: const Text('Configure Game',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(label: 'Category'),
                const SizedBox(height: 12),
                const _CategoryGrid(),
                const SizedBox(height: 28),
                _SectionHeader(label: 'Difficulty'),
                const SizedBox(height: 12),
                const _DifficultyPicker(),
                const SizedBox(height: 28),
                _SectionHeader(label: 'Questions'),
                const SizedBox(height: 12),
                const _QuestionCountPicker(),
                const SizedBox(height: 36),
                const _StartButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        color: Colors.white38,
        fontSize: 12,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    final categories = <TriviaCategory?>[null, ...TriviaCategory.values];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: categories.length,
      itemBuilder: (_, i) {
        final cat = categories[i];
        final isSelected = provider.selectedCategory == cat;
        final emoji = cat?.emoji ?? '🌌';
        final name = cat?.displayName ?? 'Mixed';
        final color = cat?.color ?? const Color(0xFF7C4DFF);

        return GestureDetector(
          onTap: () {
            provider.selectedCategory = cat;
            // ignore: invalid_use_of_protected_member
            provider.notifyListeners();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.25) : Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? color : Colors.white12,
                width: isSelected ? 1.8 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 26)),
                const SizedBox(height: 4),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? color : Colors.white60,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DifficultyPicker extends StatelessWidget {
  const _DifficultyPicker();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Row(
      children: Difficulty.values.map((d) {
        final isSelected = provider.selectedDifficulty == d;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                provider.selectedDifficulty = d;
                // ignore: invalid_use_of_protected_member
                provider.notifyListeners();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? d.color.withOpacity(0.2) : Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? d.color : Colors.white12,
                    width: isSelected ? 1.8 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      d.displayName,
                      style: TextStyle(
                        color: isSelected ? d.color : Colors.white60,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${d.basePoints} pts · ${d.timeLimit}s',
                      style: TextStyle(
                        color: isSelected ? d.color.withOpacity(0.8) : Colors.white30,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _QuestionCountPicker extends StatelessWidget {
  const _QuestionCountPicker();
  static const _counts = [5, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Row(
      children: _counts.map((n) {
        final isSelected = provider.questionCount == n;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                provider.questionCount = n;
                // ignore: invalid_use_of_protected_member
                provider.notifyListeners();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF7C4DFF).withOpacity(0.2)
                      : Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF7C4DFF) : Colors.white12,
                    width: isSelected ? 1.8 : 1,
                  ),
                ),
                child: Text(
                  '$n',
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF7C4DFF) : Colors.white60,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.read<GameProvider>().startGame();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const GameScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: const Color(0xFF7C4DFF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: const Text(
          'Start Game',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
