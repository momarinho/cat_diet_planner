import 'package:flutter/material.dart';

import '../widgets/active_cat_hero_card.dart';
import '../widgets/dashboard_blur_app_bar.dart';
import '../widgets/dashboard_daily_summary_card.dart';
import '../widgets/dashboard_meal_timeline_section.dart';
import '../widgets/dashboard_quick_actions.dart';

class DashboardOverviewScreen extends StatelessWidget {
  const DashboardOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const DashboardBlurAppBar(),
      body: const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 110, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ActiveCatHeroCard(),
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
