import 'package:cat_diet_planner/features/dashboard/screens/dashboard_overview_screen.dart';
import 'package:flutter/material.dart';

class AppShellScreen extends StatefulWidget {
  const AppShellScreen({super.key});

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  int _currentIndex = 0;

  late final List<Widget> _tabs = [
    const DashboardOverviewScreen(), // Home
    const _NutritionMockScreen(),
    const _HealthMockScreen(),
    const _ProfileMockScreen(),
  ];

  void _onTabTap(int index) {
    setState(() => _currentIndex = index);
  }

  void _onFabTap() {
    // Ação global do app (scanner / novo registro / ação rápida)
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final inactive = primary.withValues(alpha: 0.45);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.35),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _onFabTap,
          backgroundColor: primary,
          foregroundColor: Colors.black87,
          elevation: 0,
          child: const Icon(Icons.add, size: 34),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.92),
        child: Container(
          height: 72 + MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.fromLTRB(
            12,
            8,
            12,
            MediaQuery.of(context).padding.bottom + 2,
          ),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: primary.withValues(alpha: 0.10), width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  active: _currentIndex == 0,
                  activeColor: primary,
                  inactiveColor: inactive,
                  onTap: () => _onTabTap(0),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.restaurant_rounded,
                  label: 'Meals',
                  active: _currentIndex == 1,
                  activeColor: primary,
                  inactiveColor: inactive,
                  onTap: () => _onTabTap(1),
                ),
              ),
              const SizedBox(width: 56),
              Expanded(
                child: _NavItem(
                  icon: Icons.health_and_safety_rounded,
                  label: 'Health',
                  active: _currentIndex == 2,
                  activeColor: primary,
                  inactiveColor: inactive,
                  onTap: () => _onTabTap(2),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  active: _currentIndex == 3,
                  activeColor: primary,
                  inactiveColor: inactive,
                  onTap: () => _onTabTap(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? activeColor : inactiveColor;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: active ? FontWeight.w800 : FontWeight.w700,
                letterSpacing: 1.0,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionMockScreen extends StatelessWidget {
  const _NutritionMockScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Nutrition (Mock)')));
  }
}

class _HealthMockScreen extends StatelessWidget {
  const _HealthMockScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Health (Mock)')));
  }
}

class _ProfileMockScreen extends StatelessWidget {
  const _ProfileMockScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Profile (Mock)')));
  }
}
