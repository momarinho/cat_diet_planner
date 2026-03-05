import 'package:flutter/material.dart';

import 'widgets/home_header_app_bar.dart';
import 'widgets/home_cat_carousel_section.dart';
import 'widgets/home_next_feeding_card.dart';
import 'widgets/home_health_insights_card.dart';
import 'widgets/home_health_stats_grid.dart';

class HomeOverviewScreen extends StatelessWidget {
  const HomeOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeHeaderAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        child: Column(
          children: const [
            HomeCatCarouselSection(),
            SizedBox(height: 16),
            HomeNextFeedingCard(),
            SizedBox(height: 16),
            HomeHealthInsightsCard(),
            SizedBox(height: 16),
            HomeHealthStatsGrid(),
          ],
        ),
      ),
    );
  }
}
