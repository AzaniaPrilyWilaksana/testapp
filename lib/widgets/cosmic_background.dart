import 'dart:math';
import 'package:flutter/material.dart';

class CosmicBackground extends StatefulWidget {
  final Widget child;
  const CosmicBackground({super.key, required this.child});

  @override
  State<CosmicBackground> createState() => _CosmicBackgroundState();
}

class _CosmicBackgroundState extends State<CosmicBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Star> _stars = List.generate(80, (_) => _Star());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0D0221),
                Color(0xFF1A0533),
                Color(0xFF0D0C2B),
                Color(0xFF020B18),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        ),
        // Star field
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => CustomPaint(
            painter: _StarPainter(_stars, _controller.value),
            child: const SizedBox.expand(),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _Star {
  final double x = Random().nextDouble();
  final double y = Random().nextDouble();
  final double size = Random().nextDouble() * 2.5 + 0.5;
  final double phase = Random().nextDouble();
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final double animValue;

  _StarPainter(this.stars, this.animValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final twinkle = 0.3 + 0.7 * (sin((animValue + star.phase) * pi * 2) * 0.5 + 0.5);
      final paint = Paint()
        ..color = Colors.white.withOpacity(twinkle * 0.8)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarPainter old) => old.animValue != animValue;
}
