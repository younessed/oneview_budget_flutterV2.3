import 'package:flutter/material.dart';
import 'neon_donut.dart';
import 'perfect_model_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            const Center(
              child: Text(
                "Tu gères bien, continue\ncomme ça 💪",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, height: 1.15, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 18),
            NeonDonut(
              progress: .72,
              ringColors: const [Color(0xFFFF57D2), Color(0xFFB14CFF), Color(0xFF7A52FF)],
              centerAmount: "2340 MAD",
              leftLabel: "Fixes 58 %",
              rightLabel: "Dépenses du quotidien 27 %",
            ),
            const SizedBox(height: 18),
            _infoCard("🧾 Tes dépenses sont 9 % au-dessus de la moyenne nationale 💸"),
            const SizedBox(height: 14),
            _perfectButton(context),
            const SizedBox(height: 24),
            _sectionBar(
              title: "Épargne",
              percent: .72,
              info: "📊 Ton épargne est 14 % supérieure à la moyenne des profils similaires 😎",
              color: const Color(0xFF21E3C3),
            ),
            const SizedBox(height: 18),
            _sectionBar(
              title: "Provisions annuelles",
              percent: .45,
              info: "📊 Tes dépenses annuelles sont proches de la moyenne nationale ✨",
              color: const Color(0xFFFF8A3D),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _nav(),
    );
  }

  static Widget _infoCard(String t) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.06),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white.withOpacity(.08)),
    ),
    child: Text(t, style: const TextStyle(fontSize: 14)),
  );

  static Widget _perfectButton(BuildContext ctx) => GestureDetector(
    onTap: () => showPerfectModelSheet(ctx),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Color(0x804A00E0), blurRadius: 20, spreadRadius: 1)],
      ),
      alignment: Alignment.center,
      child: const Text("Voir modèle parfait",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
    ),
  );

  static Widget _sectionBar({required String title, required double percent, required String info, required Color color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children:[
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const Spacer(),
            Text("${(percent*100).round()} %", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 10),
        LayoutBuilder(builder: (context, cons){
          return Stack(
            children: [
              Container(height: 10, width: cons.maxWidth, decoration: BoxDecoration(color: Colors.white.withOpacity(.08), borderRadius: BorderRadius.circular(10))),
              Container(height: 10, width: cons.maxWidth*percent, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10))),
            ],
          );
        }),
        const SizedBox(height: 10),
        Text(info, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  static Widget _nav() => Container(
    height: 62,
    padding: const EdgeInsets.symmetric(horizontal: 22),
    decoration: const BoxDecoration(color: Color(0xFF0C0717)),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.home_rounded), Icon(Icons.history), Icon(Icons.insights_rounded),
        Icon(Icons.person_rounded), Icon(Icons.settings_rounded)
      ],
    ),
  );
}
