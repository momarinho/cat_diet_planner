import 'package:cat_diet_planner/features/daily/widgets/daily_header_app_bar.dart';
import 'package:cat_diet_planner/features/daily/widgets/daily_metrics_row.dart';
import 'package:cat_diet_planner/features/daily/widgets/daily_schedule_section.dart';
import 'package:flutter/material.dart';

class DailyOverviewScreen extends StatelessWidget {
  const DailyOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 18, 20, 132),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DailyHeaderAppBar(),
            SizedBox(height: 24),
            DailyMetricsRow(),
            SizedBox(height: 34),
            DailyScheduleSection(),
          ],
        ),
      ),
    );
  }
}
