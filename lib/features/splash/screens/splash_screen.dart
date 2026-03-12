import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const _logoPath = 'assets/images/cat_diet_logo.png';

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
                  _Dot(color: Color(0x33FF85A1)),
                  SizedBox(width: 10),
                  _Dot(color: Color(0xFFB44D6A)),
                  SizedBox(width: 10),
                  _Dot(color: Color(0x33FF85A1)),
                ],
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed(AppRoutes.shell),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(58),
                  backgroundColor: AppTheme.primaryNeon,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: const Text('Login'),
              ),
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
      width: 320,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 252,
            height: 252,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFF8B7C8), Color(0xFFA32D56)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA32D56).withValues(alpha: 0.12),
                  blurRadius: 26,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
          ),
          Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF7F1F3),
            ),
          ),
          Container(
            width: 204,
            height: 204,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.82),
                width: 3,
              ),
            ),
          ),
          ClipOval(
            child: SizedBox(
              width: 196,
              height: 196,
              child: Transform.scale(
                scale: 0.9,
                child: Image.asset(
                  SplashScreen._logoPath,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
