import 'package:flutter/material.dart';
import 'gauge_meter.dart';

Future<void> showPerfectModelSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF0F0A1C).withOpacity(.94),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(.06)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("Modèle parfait",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              SizedBox(height: 14),
              GaugeMeter(title: "Dépenses fixes", value: 30),
              SizedBox(height: 12),
              GaugeMeter(title: "Dépenses du quotidien", value: 33),
              SizedBox(height: 12),
              GaugeMeter(title: "Épargne", value: 20),
              SizedBox(height: 14),
            ],
          ),
        ),
      );
    },
  );
}
