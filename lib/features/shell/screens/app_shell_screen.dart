import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/features/daily/screens/daily_overview_screen.dart';
import 'package:cat_diet_planner/features/home/screens/home_overview_screen.dart';
import 'package:cat_diet_planner/features/plans/screens/plans_screen.dart';

import 'package:flutter/material.dart';

enum AppShellTab {
  daily('/daily', 'Daily', Icons.grid_view_rounded),
  home('/home', 'Home', Icons.home_rounded),
  plans('/plans', 'Plans', Icons.adjust_rounded),
  history('/history', 'History', Icons.bar_chart_rounded);

  const AppShellTab(this.path, this.label, this.icon);

  final String path;
  final String label;
  final IconData icon;
}

class AppShellScreen extends StatefulWidget {
  const AppShellScreen({super.key});

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  AppShellTab _currentTab = AppShellTab.daily;

  final Map<AppShellTab, Widget> _tabScreens = const {
    AppShellTab.daily: DailyOverviewScreen(),
    AppShellTab.home: HomeOverviewScreen(),
    AppShellTab.plans: PlansScreen(),
    AppShellTab.history: _HistoryMockScreen(),
  };

  void _onTabTap(AppShellTab tab) {
    setState(() => _currentTab = tab);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final activeColor = primary;
    final inactiveColor =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.55) ??
        primary.withValues(alpha: 0.45);
    final showDailyScanner = _currentTab == AppShellTab.daily;

    return Scaffold(
      body: IndexedStack(
        index: AppShellTab.values.indexOf(_currentTab),
        children: AppShellTab.values.map((tab) => _tabScreens[tab]!).toList(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.96),
        elevation: 0,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 86 + MediaQuery.of(context).padding.bottom,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 74 + MediaQuery.of(context).padding.bottom,
                margin: const EdgeInsets.only(top: 12),
                padding: EdgeInsets.fromLTRB(
                  12,
                  6,
                  12,
                  MediaQuery.of(context).padding.bottom + 4,
                ),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor.withValues(alpha: 0.96),
                  border: Border(
                    top: BorderSide(
                      color: primary.withValues(alpha: 0.12),
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 24,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _NavItem(
                        tab: AppShellTab.daily,
                        currentTab: _currentTab,
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                        onTap: () => _onTabTap(AppShellTab.daily),
                      ),
                    ),
                    Expanded(
                      child: _NavItem(
                        tab: AppShellTab.home,
                        currentTab: _currentTab,
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                        onTap: () => _onTabTap(AppShellTab.home),
                      ),
                    ),
                    SizedBox(width: showDailyScanner ? 72 : 0),
                    Expanded(
                      child: _NavItem(
                        tab: AppShellTab.plans,
                        currentTab: _currentTab,
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                        onTap: () => _onTabTap(AppShellTab.plans),
                      ),
                    ),
                    Expanded(
                      child: _NavItem(
                        tab: AppShellTab.history,
                        currentTab: _currentTab,
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                        onTap: () => _onTabTap(AppShellTab.history),
                      ),
                    ),
                  ],
                ),
              ),
              if (showDailyScanner)
                Positioned(
                  top: 0,
                  child: _DailyScannerButton(onTap: _onScannerTap),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onScannerTap() => Navigator.of(context).pushNamed(AppRoutes.scanner);
}

class _NavItem extends StatelessWidget {
  final AppShellTab tab;
  final AppShellTab currentTab;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.tab,
    required this.currentTab,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = tab == currentTab;
    final color = active ? activeColor : inactiveColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(tab.icon, color: color, size: 24),
            const SizedBox(height: 3),
            Text(
              tab.label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: active ? FontWeight.w900 : FontWeight.w800,
                letterSpacing: 0.5,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyScannerButton extends StatelessWidget {
  final VoidCallback onTap;

  const _DailyScannerButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: primary,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.9),
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.28),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}

class _HistoryMockScreen extends StatelessWidget {
  const _HistoryMockScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('History (Mock)')));
  }
}
