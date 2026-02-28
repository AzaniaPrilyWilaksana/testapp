import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiWidget extends StatefulWidget {
  const ConfettiWidget({super.key});

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Piece> _pieces = List.generate(30, (_) => _Piece());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => CustomPaint(
          painter: _ConfettiPainter(_pieces, _controller.value),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _Piece {
  final double x = Random().nextDouble();
  final double fallSpeed = 0.2 + Random().nextDouble() * 0.8;
  final double rotateSpeed = Random().nextDouble() * 4 - 2;
  final double size = 6.0 + Random().nextDouble() * 8;
  final Color color = [
    const Color(0xFFE57373),
    const Color(0xFFFFD54F),
    const Color(0xFF81C784),
    const Color(0xFF64B5F6),
    const Color(0xFFBA68C8),
    const Color(0xFFF06292),
  ][Random().nextInt(6)];
}

class _ConfettiPainter extends CustomPainter {
  final List<_Piece> pieces;
  final double t;

  _ConfettiPainter(this.pieces, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pieces) {
      final y = (t * p.fallSpeed * size.height * 1.2) - p.size;
      final opacity = (1 - t).clamp(0.0, 1.0);
      if (opacity <= 0) continue;

      final paint = Paint()..color = p.color.withOpacity(opacity);
      canvas.save();
      canvas.translate(p.x * size.width, y);
      canvas.rotate(t * p.rotateSpeed * 2 * pi);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
