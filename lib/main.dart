import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const OneViewApp());
}

class OneViewApp extends StatelessWidget {
  const OneViewApp({super.key});
  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: textTheme,
        scaffoldBackgroundColor: const Color(0xFF0E081A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8A5CF6),
          secondary: Color(0xFF00E0C7),
          surface: Color(0xFF171025),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // BACKGROUND dégradé + glow
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F0A1F), Color(0xFF120C28)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -120,
              left: -80,
              child: _GlowCircle(size: 260, color1: Color(0xFF8A5CF6), color2: Color(0xFFFF4EC8)),
            ),
            Positioned(
              bottom: -140,
              right: -80,
              child: _GlowCircle(size: 300, color1: Color(0xFF6A5BFF), color2: Color(0xFF00E0C7)),
            ),

            // CONTENU
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Text(
                    "Tu gères bien, continue\ncomme ça 💪",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      shadows: [Shadow(color: Colors.black.withOpacity(.35), blurRadius: 8)],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // DONUT style néon
                const _NeonDonut(balanceText: "2340 MAD", fixedPct: 58, variablePct: 27),

                const SizedBox(height: 14),

                // Info moyenne
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: _InfoBubble(
                    text: "📑 Tes dépenses sont 9 % au-dessus de la moyenne nationale 💸",
                  ),
                ),

                const SizedBox(height: 14),

                // Bouton Voir modèle parfait
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: _NeonButton(
                    label: "Voir modèle parfait",
                    onTap: () => _showPerfectModel(context),
                  ),
                ),

                const SizedBox(height: 18),

                // ÉPARGNE
                _SectionBar(
                  title: "Épargne",
                  percentText: "72 %",
                  percent: .72,
                  barColor: const Color(0xFF00E0C7),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 6, 18, 0),
                  child: _InfoLine(text: "📊 Ton épargne est 14 % supérieure à la moyenne des profils similaires 😎"),
                ),

                const SizedBox(height: 14),

                // PROVISIONS ANNUELLES
                _SectionBar(
                  title: "Provisions annuelles",
                  percentText: "45 %",
                  percent: .45,
                  barColor: const Color(0xFFFF8C3A),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 6, 18, 8),
                  child: _InfoLine(text: "📊 Tes dépenses annuelles sont proches de la moyenne nationale ✨"),
                ),

                const Spacer(),

                // NAV BAR custom (pas de chevauchement)
                const _BottomNav(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _showPerfectModel(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _GlassSheet(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(height: 6),
                Text("Modèle parfait", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                SizedBox(height: 16),
                _GaugeRow(label: "Dépenses fixes", valuePct: 30),
                SizedBox(height: 12),
                _GaugeRow(label: "Dépenses du quotidien", valuePct: 33),
                SizedBox(height: 12),
                _GaugeRow(label: "Épargne", valuePct: 20),
                SizedBox(height: 18),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------- UI widgets ----------

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color1, color2;
  const _GlowCircle({required this.size, required this.color1, required this.color2});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color1.withOpacity(.35), color2.withOpacity(.15), Colors.transparent]),
        boxShadow: [BoxShadow(color: color1.withOpacity(.25), blurRadius: 80, spreadRadius: 30)],
      ),
    );
  }
}

class _NeonDonut extends StatelessWidget {
  final String balanceText;
  final int fixedPct;
  final int variablePct;
  const _NeonDonut({required this.balanceText, required this.fixedPct, required this.variablePct});

  @override
  Widget build(BuildContext context) {
    final ring = LinearGradient(colors: const [Color(0xFFFF4EC8), Color(0xFF8A5CF6), Color(0xFF6A5BFF)]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: AspectRatio(
        aspectRatio: 1.2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // halo
            Container(
              width: double.infinity, height: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: const Color(0xFF8A5CF6).withOpacity(.45), blurRadius: 80, spreadRadius: 10)],
              ),
            ),
            // anneau
            CustomPaint(
              size: const Size(double.infinity, double.infinity),
              painter: _ArcPainter(gradient: ring, sweep: 260),
            ),
            // montant
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(balanceText, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Chip("Fixes ${fixedPct} %"),
                    const SizedBox(width: 12),
                    _Chip("Dépenses du quotidien ${variablePct} %"),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final LinearGradient gradient;
  final double sweep; // en degrés
  _ArcPainter({required this.gradient, this.sweep = 260});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: size.shortestSide * .42);
    final start = -90 * 3.14159 / 180; // en haut
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * .08
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(rect);

    // arrière (ombre)
    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * .08
      ..color = Colors.white.withOpacity(.06);

    canvas.drawArc(rect, 0, 6.283, false, bg);
    canvas.drawArc(rect, start, sweep * 3.14159 / 180, false, paint);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) => false;
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _InfoBubble extends StatelessWidget {
  final String text;
  const _InfoBubble({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 15, height: 1.35)),
    );
  }
}

class _NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NeonButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(colors: [Color(0xFF8A5CF6), Color(0xFF6A5BFF)]),
          boxShadow: [
            BoxShadow(color: const Color(0xFF8A5CF6).withOpacity(.4), blurRadius: 20, spreadRadius: 1, offset: const Offset(0, 8))
          ],
        ),
        child: const Center(
          child: Text("Voir modèle parfait", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}

class _SectionBar extends StatelessWidget {
  final String title;
  final String percentText;
  final double percent; // 0..1
  final Color barColor;
  const _SectionBar({required this.title, required this.percentText, required this.percent, required this.barColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text(percentText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 12,
              backgroundColor: Colors.white.withOpacity(.08),
              color: barColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String text;
  const _InfoLine({required this.text});
  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 15, height: 1.35));
  }
}

class _GlassSheet extends StatelessWidget {
  final Widget child;
  const _GlassSheet({required this.child});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.only(bottom: 12, top: 6),
          color: Colors.white.withOpacity(.06),
          child: child,
        ),
      ),
    );
  }
}

/// Jauge horizontale animée style “aiguille”
class _GaugeRow extends StatelessWidget {
  final String label;
  final int valuePct; // 0..100
  const _GaugeRow({required this.label, required this.valuePct});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Gauge(valuePct: valuePct),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text("$valuePct %", style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Gauge extends StatefulWidget {
  final int valuePct;
  const _Gauge({required this.valuePct});
  @override
  State<_Gauge> createState() => _GaugeState();
}

class _GaugeState extends State<_Gauge> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _a = Tween<double>(begin: 0, end: widget.valuePct / 100).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: AnimatedBuilder(
        animation: _a,
        builder: (_, __) {
          return CustomPaint(
            painter: _GaugePainter(progress: _a.value),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress; // 0..1
  _GaugePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final track = Paint()
      ..color = Colors.white.withOpacity(.07)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0, size.height / 2 - 7, size.width, 14);
    // piste
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(999)), track);

    // barre gradient
    final bar = Paint()
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..shader = const LinearGradient(
        colors: [Color(0xFF00E0C7), Color(0xFF6A5BFF), Color(0xFFFF4EC8)],
      ).createShader(rect);

    final endX = rect.left + rect.width * progress;
    final path = Path()
      ..moveTo(rect.left, rect.center.dy)
      ..lineTo(endX, rect.center.dy);
    canvas.drawPath(path, bar);

    // aiguille (petit trait oblique)
    final needlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    final nx = endX;
    final ny = rect.center.dy;
    canvas.drawLine(Offset(nx - 10, ny - 16), Offset(nx + 2, ny + 8), needlePaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) => oldDelegate.progress != progress;
}

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
