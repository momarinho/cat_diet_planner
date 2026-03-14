import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:flutter/material.dart';

class DailyScannerCta extends StatelessWidget {
  const DailyScannerCta({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Positioned(
      right: 20,
      bottom: 96 + bottomInset,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.scanner);
          },
          customBorder: const CircleBorder(),
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.35),
                  blurRadius: 34,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
