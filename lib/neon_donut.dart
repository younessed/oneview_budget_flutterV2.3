import 'dart:ui';
import 'package:flutter/material.dart';

class NeonDonut extends StatelessWidget {
  final double progress;       // 0..1
  final List<Color> ringColors;
  final String centerAmount;
  final String leftLabel;
  final String rightLabel;

  const NeonDonut({
    super.key,
    required this.progress,
    required this.ringColors,
    required this.centerAmount,
    required this.leftLabel,
    required this.rightLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 300, height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ringColors.last.withOpacity(.35),
                blurRadius: 120, spreadRadius: 30,
              ),
            ],
          ),
        ),
        Container(
          width: 260, height: 260,
          decoration: BoxDecoration(
            color: const Color(0xFF120A22),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.45),
                blurRadius: 30, spreadRadius: 1,
                offset: const Offset(0, 10),
              ),
            ],
          ),
        ),
        CustomPaint(
          size: const Size(280, 280),
          painter: _DonutPainter(progress, ringColors),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              centerAmount,
              style: const TextStyle(
                fontSize: 36, fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _chip(leftLabel),
                const SizedBox(width: 12),
                _chip(rightLabel),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _chip(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.06),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white.withOpacity(.08)),
    ),
    child: Text(text, style: const TextStyle(fontSize: 14)),
  );
}

class _DonutPainter extends CustomPainter {
  final double p;
  final List<Color> colors;
  _DonutPainter(this.p, this.colors);

  @override
  void paint(Canvas c, Size s) {
    final stroke = 22.0;

    final bg = Paint()
      ..color = const Color(0xFF1A132A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    c.drawArc(
      Rect.fromLTWH(stroke, stroke, s.width - 2*stroke, s.height - 2*stroke),
      -1.2, 2.4, false, bg,
    );

    final grad = SweepGradient(
      colors: colors,
      startAngle: -1.2,
      endAngle: -1.2 + 2.4 * p,
    );
    final fg = Paint()
      ..shader = grad.createShader(Offset.zero & s)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
      ..strokeWidth = stroke;
    c.drawArc(
      Rect.fromLTWH(stroke, stroke, s.width - 2*stroke, s.height - 2*stroke),
      -1.2, 2.4 * p, false, fg,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.p != p || old.colors != colors;
}
