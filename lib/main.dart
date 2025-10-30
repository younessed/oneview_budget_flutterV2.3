import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OneViewApp());
}

class OneViewApp extends StatelessWidget {
  const OneViewApp({super.key});
  @override
  Widget build(BuildContext context) {
    final seed = const Color(0xFF7C4DFF);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OneView Budget',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: seed,
      ),
      home: const Shell(),
    );
  }
}

/// ==== SHELL AVEC BOTTOM NAV ====
class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const DashboardPage(),
      const PlaceholderPage(title: 'Historique'),
      const PlaceholderPage(title: 'Analyses'),
      const PlaceholderPage(title: 'Profil'),
      const PlaceholderPage(title: 'Réglages'),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: pages[_index],
      ),
      bottomNavigationBar: NavigationBar(
        height: 68,
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.history_rounded), label: 'Historique'),
          NavigationDestination(icon: Icon(Icons.auto_graph_rounded), label: 'Analyses'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.settings_rounded), label: 'Réglages'),
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

/// ==== DASHBOARD (anneau animé + bouton “voir modèle parfait”) ====
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // valeurs démo (utilisées aussi par la page détail via arguments)
  double total = 2340;
  double pFixes = 0.58;
  double pQuot = 0.33;
  double pEpargne = 0.09; // somme = 1.00

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          const SizedBox(height: 4),
          Text(
            'Tu gères bien,\ncontinue comme ça 💪',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, height: 1.1),
          ),
          const SizedBox(height: 12),

          // Anneau animé
          AspectRatio(
            aspectRatio: 1.05,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: pFixes),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (_, v, __) => CustomPaint(
                painter: _DonutPainter(progress: v, color1: cs.secondary, color2: cs.primary),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${total.toStringAsFixed(0)} MAD',
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Text('Fixes ${(v * 100).toStringAsFixed(0)} %',
                          style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(.85))),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),
          // bouton -> page détail
          FilledButton.tonal(
            onPressed: () async {
              final result = await Navigator.of(context).push<_ModeleData>(
                MaterialPageRoute(
                  builder: (_) => ModeleParfaitPage(
                    data: _ModeleData(pFixes, pQuot, pEpargne),
                  ),
                ),
              );
              if (result != null) {
                setState(() {
                  pFixes = result.fixes;
                  pQuot = result.quotidien;
                  pEpargne = result.epargne;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Modèle mis à jour ✅')),
                );
              }
            },
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            child: const Text('Voir modèle parfait'),
          ),

          const SizedBox(height: 18),
          // Résumé cliquable (ouvre aussi détail)
          _GaugeLineTile(
            label: 'Dépenses fixes',
            value: pFixes,
            onTap: () => _openDetail(context, focusIndex: 0),
          ),
          _GaugeLineTile(
            label: 'Dépenses du quotidien',
            value: pQuot,
            onTap: () => _openDetail(context, focusIndex: 1),
          ),
          _GaugeLineTile(
            label: 'Épargne',
            value: pEpargne,
            onTap: () => _openDetail(context, focusIndex: 2),
          ),
        ],
      ),
    );
  }

  Future<void> _openDetail(BuildContext context, {required int focusIndex}) async {
    final result = await Navigator.of(context).push<_ModeleData>(
      MaterialPageRoute(
        builder: (_) => ModeleParfaitPage(
          data: _ModeleData(pFixes, pQuot, pEpargne),
          focusIndex: focusIndex,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        pFixes = result.fixes;
        pQuot = result.quotidien;
        pEpargne = result.epargne;
      });
    }
  }
}

/// ==== PAGE DÉTAIL INTERACTIVE (modèle parfait) ====
class ModeleParfaitPage extends StatefulWidget {
  final _ModeleData data;
  final int? focusIndex; // 0 fixes, 1 quotidien, 2 épargne
  const ModeleParfaitPage({super.key, required this.data, this.focusIndex});

  @override
  State<ModeleParfaitPage> createState() => _ModeleParfaitPageState();
}

class _ModeleParfaitPageState extends State<ModeleParfaitPage> {
  late double fixes, quotidien, epargne;

  @override
  void initState() {
    super.initState();
    fixes = widget.data.fixes;
    quotidien = widget.data.quotidien;
    epargne = widget.data.epargne;
  }

  void _rebalanceFrom(String changed) {
    // Maintient la somme = 1.0 en rééquilibrant proportionnellement
    double other1, other2;
    if (changed == 'fixes') {
      other1 = quotidien; other2 = epargne;
    } else if (changed == 'quotidien') {
      other1 = fixes; other2 = epargne;
    } else {
      other1 = fixes; other2 = quotidien;
    }
    double rest = 1.0 - (changed == 'fixes' ? fixes : changed == 'quotidien' ? quotidien : epargne);
    rest = rest.clamp(0.0, 1.0);
    final totalOthers = (other1 + other2).clamp(1e-6, 10.0);
    final o1 = rest * (other1 / totalOthers);
    final o2 = rest * (other2 / totalOthers);
    if (changed == 'fixes') { quotidien = o1; epargne = o2; }
    if (changed == 'quotidien') { fixes = o1; epargne = o2; }
    if (changed == 'epargne') { fixes = o1; quotidien = o2; }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Modèle parfait')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        children: [
          _EditableGaugeTile(
            label: 'Dépenses fixes',
            value: fixes,
            color: cs.primary,
            onChanged: (v) => setState(() { fixes = v; _rebalanceFrom('fixes'); }),
          ),
          _EditableGaugeTile(
            label: 'Dépenses du quotidien',
            value: quotidien,
            color: cs.tertiary,
            onChanged: (v) => setState(() { quotidien = v; _rebalanceFrom('quotidien'); }),
          ),
          _EditableGaugeTile(
            label: 'Épargne',
            value: epargne,
            color: cs.secondary,
            onChanged: (v) => setState(() { epargne = v; _rebalanceFrom('epargne'); }),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_ModeleData(fixes, quotidien, epargne)),
            child: const Text('Enregistrer le modèle'),
          ),
        ],
      ),
    );
  }
}

class _ModeleData {
  final double fixes, quotidien, epargne;
  const _ModeleData(this.fixes, this.quotidien, this.epargne);
}

/// ==== WIDGETS RÉUTILISABLES ====

class _GaugeLineTile extends StatelessWidget {
  final String label;
  final double value; // 0..1
  final VoidCallback? onTap;
  const _GaugeLineTile({super.key, required this.label, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(.06)),
        ),
        child: Column(
          children: [
            _LineGauge(progress: value),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                Text('${(value * 100).toStringAsFixed(0)} %',
                    style: TextStyle(color: Colors.white.withOpacity(.9))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EditableGaugeTile extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;
  const _EditableGaugeTile({super.key, required this.label, required this.value, required this.color, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LineGauge(progress: value, color: color),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
              Text('${(value * 100).toStringAsFixed(0)} %'),
            ],
          ),
          Slider(
            value: value,
            onChanged: onChanged,
            min: 0,
            max: 1,
            divisions: 100,
          ),
        ],
      ),
    );
  }
}

class _LineGauge extends StatelessWidget {
  final double progress;
  final Color? color;
  const _LineGauge({super.key, required this.progress, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return SizedBox(
      height: 22,
      child: LayoutBuilder(builder: (context, cons) {
        final w = cons.maxWidth;
        final p = (w * progress).clamp(0, w);
        return Stack(children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.10),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Container(
            height: 8,
            width: p,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [c.withOpacity(.15), c]),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Positioned(
            left: p - 6,
            top: 0,
            bottom: 0,
            child: Transform.rotate(
              angle: -0.55,
              child: Container(width: 3, height: 18, color: Colors.white),
            ),
          ),
        ]);
      }),
    );
  }
}

/// ==== PAINTER DU DONUT ====
class _DonutPainter extends CustomPainter {
  final double progress; // 0..1
  final Color color1;
  final Color color2;
  _DonutPainter({required this.progress, required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.40;

    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 26
      ..color = Colors.white.withOpacity(.10);

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 26
      ..shader = SweepGradient(colors: [color1, color2], startAngle: 0, endAngle: math.pi * 2)
          .createShader(Rect.fromCircle(center: center, radius: radius));

    // base
    canvas.drawCircle(center, radius, bg);

    // progression
    final start = -math.pi / 2;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start, math.pi * 2 * progress, false, arc);
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => oldDelegate.progress != progress;
}
