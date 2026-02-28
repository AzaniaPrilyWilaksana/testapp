import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/cosmic_background.dart';
import 'category_select_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return CosmicBackground(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                const Text(
                  '✨',
                  style: TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 16),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFE040FB), Color(0xFF7C4DFF)],
                  ).createShader(bounds),
                  child: const Text(
                    'Cosmic Trivia',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Astrology & Spiritual Wisdom',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 48),

                // High score
                if (provider.highScore > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🏆', style: TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Text(
                          'Best: ${provider.highScore} pts',
                          style: const TextStyle(
                            color: Color(0xFFFFD54F),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Play button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CategorySelectScreen(),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: const Color(0xFF7C4DFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Play Now',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Category preview grid
                const Text(
                  'Explore 8 mystical categories',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    '♈ Zodiac', '🪐 Planets', '🃏 Tarot', '🌀 Chakras',
                    '💎 Crystals', '🔢 Numerology', '🌙 Moon', '✨ Mythology',
                  ].map((label) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
