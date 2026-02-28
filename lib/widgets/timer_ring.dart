import 'dart:math';
import 'package:flutter/material.dart';

class TimerRing extends StatelessWidget {
  final double timeRemaining;
  final double totalTime;
  final double size;

  const TimerRing({
    super.key,
    required this.timeRemaining,
    required this.totalTime,
    this.size = 80,
  });

  Color get _ringColor {
    final ratio = timeRemaining / totalTime;
    if (ratio > 0.5) return const Color(0xFF81C784); // green
    if (ratio > 0.25) return const Color(0xFFFFD54F); // yellow
    return const Color(0xFFE57373); // red
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          progress: timeRemaining / totalTime,
          color: _ringColor,
        ),
        child: Center(
          child: Text(
            timeRemaining.ceil().toString(),
            style: TextStyle(
              color: _ringColor,
              fontSize: size * 0.32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;

    // Background ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withOpacity(0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );

    // Progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}
