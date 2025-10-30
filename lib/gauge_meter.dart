import 'dart:math';
import 'package:flutter/material.dart';

class GaugeMeter extends StatelessWidget {
  final String title;   // ex: "Dépenses fixes"
  final double value;   // 0..100

  const GaugeMeter({super.key, required this.title, required this.value});

  Color get color {
    if (value < 34) return const Color(0xFF20E3B2);   // vert
    if (value < 67) return const Color(0xFFFFA33C);   // orange
    return const Color(0xFFFF4D67);                   // rouge
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF140E24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.06)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: value),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (_, v, __) => CustomPaint(
                size: const Size(double.infinity, 80),
                painter: _GaugePainter(v/100, color),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(title, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 4),
              Text("${value.toStringAsFixed(0)} %",
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double p; // 0..1
  final Color color;
  _GaugePainter(this.p, this.color);

  @override
  void paint(Canvas c, Size s) {
    final base = Paint()
      ..color = const Color(0xFF2A203E)
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final arc = Rect.fromLTWH(0, 10, s.width, s.height-20);
    c.drawArc(arc, pi, pi, false, base);

    // aiguille
    final needlePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final center = Offset(s.width/2, s.height/2);
    final angle = pi + pi * p; // gauche->droite
    final radius = s.width/2 - 8;
    final tip = Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle));
    c.drawLine(center, tip, needlePaint);
    c.drawCircle(tip, 5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter old) => old.p != p || old.color != color;
}
