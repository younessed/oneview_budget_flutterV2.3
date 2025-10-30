import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';

void main() {
  // on s’assure qu’aucun overlay/debug n’est actif, surtout en release
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OneView Budget',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF8A2BE2), // violet néon
      ),
      home: const _Dashboard(),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({super.key});

  // valeurs démo – adapte selon tes calculs
  static const double totalMAD = 2340;
  static const double percentFixes = 0.58;
  static const double percentQuotidien = 0.33;
  static const double percentEpargne = 0.20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // fond doux
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF130B24), Color(0xFF1E1140)],
              ),
            ),
          ),

          // contenu
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
              children: [
                const _Headline(),
                const SizedBox(height: 24),

                // donut progress (ton anneau)
                AspectRatio(
                  aspectRatio: 1.1,
                  child: CustomPaint(
                    painter: _GaugePainter(progress: percentFixes),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${totalMAD.toStringAsFixed(0)} MAD',
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Fixes ${(percentFixes * 100).toStringAsFixed(0)} %',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                _CardModeleParfait(
                  fixes: percentFixes,
                  quotidien: percentQuotidien,
                  epargne: percentEpargne,
                ),
              ],
            ),
          ),

          // bottom bar
          const Align(
            alignment: Alignment.bottomCenter,
            child: _BottomNav(),
          ),
        ],
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Tu gères bien,\ncontinue comme ça 💪',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        height: 1.15,
        color: Colors.white.withOpacity(.95),
        // pas de soulignement/spans spéciaux ici → texte propre
      ),
    );
  }
}

class _CardModeleParfait extends StatelessWidget {
  final double fixes;
  final double quotidien;
  final double epargne;
  const _CardModeleParfait({
    super.key,
    required this.fixes,
    required this.quotidien,
    required this.epargne,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(.08)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Modèle parfait',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 16),
          _LineGauge(label: 'Dépenses fixes', value: fixes),
          _LineGauge(label: 'Dépenses du quotidien', value: quotidien),
          _LineGauge(label: 'Épargne', value: epargne),
        ],
      ),
    );
  }
}

class _LineGauge extends StatelessWidget {
  final String label;
  final double value; // 0..1
  const _LineGauge({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 22,
            child: LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                return Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.10),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    Container(
                      height: 8,
                      width: w * value,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00E5FF), Color(0xFF5E5BFF)],
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    // aiguille
                    Positioned(
                      left: w * value - 6,
                      top: 0,
                      bottom: 0,
                      child: Transform.rotate(
                        angle: -0.6,
                        child: Container(
                          width: 3,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                '${(value * 100).toStringAsFixed(0)} %',
                style:
                    TextStyle(color: Colors.white.withOpacity(.9), fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ====== TON PAINTER (intégré tel que fourni) ======

class _GaugePainter extends CustomPainter {
  final double progress; // 0..1

  _GaugePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.42;

    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withOpacity(.10);

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        colors: [Color(0xFFDE3EFF), Color(0xFF6A5BFF)],
        startAngle: 0.0,
        endAngle: 6.28318, // 2π
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    // cercle de base
    canvas.drawCircle(center, radius, base);

    // arc de progression
    final start = -3.14159 / 2; // en haut
    final sweep = 6.28318 * progress;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, start, sweep, false, arc);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// ====== TON BOTTOM NAV (intégré tel que fourni) ======

class _BottomNav extends StatelessWidget {
  const _BottomNav({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(Icons.home_rounded, color: Colors.white, size: 26),
          Icon(Icons.access_time_filled, color: Colors.white70, size: 24),
          Icon(Icons.auto_graph_rounded, color: Colors.white70, size: 24),
          Icon(Icons.person_rounded, color: Colors.white70, size: 24),
          Icon(Icons.settings_rounded, color: Colors.white70, size: 24),
        ],
      ),
    );
  }
}
