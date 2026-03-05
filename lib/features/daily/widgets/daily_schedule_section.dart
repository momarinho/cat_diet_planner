import 'package:cat_diet_planner/core/theme/app_theme.dart';
import 'package:cat_diet_planner/core/widgets/app_card_container.dart';
import 'package:cat_diet_planner/core/widgets/status_badge.dart';
import 'package:cat_diet_planner/core/widgets/vertical_timeline_tile.dart';
import 'package:flutter/material.dart';

class DailyScheduleSection extends StatelessWidget {
  const DailyScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Today's Schedule",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'Oct 24, 2023',
                style: TextStyle(color: primary, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const _ScheduleCard(
          icon: Icons.check,
          title: 'Morning Meal',
          subtitle: 'High Protein Mix • 80 kcal',
          time: '07:30 AM',
          isDone: true,
          badgeText: 'COMPLETED',
          isLast: false,
        ),
        const _ScheduleCard(
          icon: Icons.hourglass_bottom_rounded,
          title: 'Weight Check-in',
          subtitle: 'Weekly progress update',
          time: '10:00 AM',
          actionLabel: 'RECORD WEIGHT',
          isLast: false,
        ),
        const _ScheduleCard(
          icon: Icons.restaurant_rounded,
          title: 'Afternoon Treat',
          subtitle: 'Dental Chew • 25 kcal',
          time: '03:00 PM',
          isMuted: true,
          isLast: false,
        ),
        const _ScheduleCard(
          icon: Icons.opacity_rounded,
          title: 'Water Fountain Clean',
          subtitle: 'Weekly maintenance',
          time: '05:00 PM',
          isMuted: true,
          isLast: false,
        ),
        const _ScheduleCard(
          icon: Icons.dinner_dining,
          title: 'Dinner',
          subtitle: 'Wet Food Mix • 135 kcal',
          time: '07:00 PM',
          isMuted: true,
          isLast: true,
        ),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final bool isDone;
  final bool isMuted;
  final bool isLast;
  final String? badgeText;
  final String? actionLabel;

  const _ScheduleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isLast,
    this.isDone = false,
    this.isMuted = false,
    this.badgeText,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final nodeColor = isDone ? primary : primary.withValues(alpha: 0.75);

    return Opacity(
      opacity: isMuted ? 0.45 : 1.0,
      child: AppCardContainer(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                VerticalTimelineTile(
                  icon: icon,
                  title: title,
                  subtitle: subtitle,
                  isLast: true,
                  nodeColor: nodeColor,
                ),
                Positioned(
                  top: 2,
                  right: 0,
                  child: Text(
                    time,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (badgeText != null) ...[
              const SizedBox(height: 2),
              const Padding(
                padding: EdgeInsets.only(left: 44),
                child: StatusBadge(
                  text: 'COMPLETED',
                  baseColor: AppTheme.successGreen,
                ),
              ),
            ],
            if (actionLabel != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 44),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(actionLabel!),
                  ),
                ),
              ),
            ],
            if (!isLast)
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 4),
                child: Container(
                  width: 3,
                  height: 58,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
