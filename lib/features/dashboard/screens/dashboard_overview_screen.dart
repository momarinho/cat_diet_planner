import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:flutter/material.dart';

import '../widgets/active_cat_hero_card.dart';
import '../widgets/dashboard_blur_app_bar.dart';
import '../widgets/dashboard_daily_summary_card.dart';
import '../widgets/dashboard_meal_timeline_section.dart';
import '../widgets/dashboard_quick_actions.dart';

class DashboardOverviewScreen extends StatelessWidget {
  final CatProfile cat;

  const DashboardOverviewScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const DashboardBlurAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 110, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ActiveCatHeroCard(cat: cat),
            SizedBox(height: 16),
            DashboardQuickActions(),
            SizedBox(height: 16),
            DashboardDailySummaryCard(),
            SizedBox(height: 16),
            DashboardMealTimelineSection(),
          ],
        ),
      ),
    );
  }
}
