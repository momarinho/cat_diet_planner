import 'package:cat_diet_planner/core/widgets/neon_button.dart';
import 'package:flutter/material.dart';

class DailyScannerCta extends StatelessWidget {
  const DailyScannerCta({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 84,
      child: SizedBox(
        width: 220,
        child: NeonButton(text: 'FOOD SCANNER', onTap: () {}),
      ),
    );
  }
}
