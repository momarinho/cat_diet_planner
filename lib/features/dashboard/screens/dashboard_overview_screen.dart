import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/dashboard_summary_provider.dart';
import '../widgets/active_cat_hero_card.dart';
import '../widgets/dashboard_blur_app_bar.dart';
import '../widgets/dashboard_daily_summary_card.dart';
import '../widgets/dashboard_meal_timeline_section.dart';
import '../widgets/dashboard_quick_actions.dart';

class DashboardOverviewScreen extends ConsumerWidget {
  final CatProfile cat;

  const DashboardOverviewScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardSummaryProvider(cat));
    final selectedCat = ref.watch(selectedCatProvider);

    if (selectedCat?.id != cat.id) {
      Future.microtask(() {
        ref.read(selectedCatProvider.notifier).state = cat;
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const DashboardBlurAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 110, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ActiveCatHeroCard(
              cat: cat,
              onEditTap: () {
                Navigator.of(
                  context,
                ).pushNamed(AppRoutes.catProfile, arguments: cat);
              },
            ),
            SizedBox(height: 16),
            DashboardQuickActions(cat: cat),
            SizedBox(height: 16),
            DashboardDailySummaryCard(summary: summary),
            SizedBox(height: 16),
            DashboardMealTimelineSection(summary: summary),
          ],
        ),
      ),
    );
  }
}
