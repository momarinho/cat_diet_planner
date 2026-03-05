import 'package:cat_diet_planner/features/daily/widgets/daily_header_app_bar.dart';
import 'package:cat_diet_planner/features/daily/widgets/daily_metrics_row.dart';
import 'package:cat_diet_planner/features/daily/widgets/daily_scanner_cta.dart';
import 'package:cat_diet_planner/features/daily/widgets/daily_schedule_section.dart';
import 'package:flutter/material.dart';

class DailyOverviewScreen extends StatelessWidget {
  const DailyOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DailyHeaderAppBar(),
      body: Stack(
        children: const [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DailyMetricsRow(),
                SizedBox(height: 24),
                DailyScheduleSection(),
              ],
            ),
          ),
          DailyScannerCta(),
        ],
      ),
    );
  }
}
