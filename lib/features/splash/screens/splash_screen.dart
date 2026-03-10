import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const _BrandMark(),
              const SizedBox(height: 36),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.2,
                  ),
                  children: const [
                    TextSpan(
                      text: 'CatDiet ',
                      style: TextStyle(color: AppTheme.primaryNeon),
                    ),
                    TextSpan(
                      text: 'Planner',
                      style: TextStyle(color: AppTheme.lightTextPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'VETERINARY-GRADE NUTRITION',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF94A0B5),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
              const Spacer(flex: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _Dot(active: true),
                  SizedBox(width: 10),
                  _Dot(active: true, faded: true),
                  SizedBox(width: 10),
                  _Dot(active: false),
                ],
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed(AppRoutes.shell),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(220, 58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryNeon.withValues(alpha: 0.55),
                width: 10,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryNeon.withValues(alpha: 0.16),
                  blurRadius: 28,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
          ),
          Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF4EFF1),
            ),
          ),
          Container(
            width: 165,
            height: 165,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryNeon,
            ),
            child: const Icon(
              Icons.pets_rounded,
              color: Colors.white,
              size: 84,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active, this.faded = false});

  final bool active;
  final bool faded;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? AppTheme.primaryNeon.withValues(alpha: faded ? 0.55 : 0.95)
            : AppTheme.primaryNeon.withValues(alpha: 0.22),
      ),
    );
  }
}
