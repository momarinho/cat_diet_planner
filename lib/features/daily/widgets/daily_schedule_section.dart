import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DailyScheduleSection extends StatelessWidget {
  const DailyScheduleSection({
    super.key,
    required this.schedule,
    required this.onMealToggle,
  });

  final List<Map<String, dynamic>> schedule;
  final ValueChanged<Map<String, dynamic>> onMealToggle;

  String _todayLabel() {
    final now = DateTime.now();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final dateBackground = theme.brightness == Brightness.dark
        ? primary.withValues(alpha: 0.14)
        : Colors.white.withValues(alpha: 0.72);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          runSpacing: 12,
          spacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "Today's Schedule",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -1.2,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                color: dateBackground,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                _todayLabel(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        ..._buildEntries(context),
      ],
    );
  }

  List<Widget> _buildEntries(BuildContext context) {
    final entries = <Widget>[];
    final mealEntries = schedule;

    for (var index = 0; index < mealEntries.length; index++) {
      final item = mealEntries[index];
      final completed = item['completed'] == true;
      final isLastMeal = index == mealEntries.length - 1;

      entries.add(
        _ScheduleEntry(
          icon: completed ? Icons.check_rounded : Icons.restaurant_rounded,
          title: item['title'] as String? ?? 'Meal',
          subtitle: item['subtitle'] as String? ?? '',
          time: item['time'] as String? ?? '',
          state: completed ? _ScheduleState.completed : _ScheduleState.upcoming,
          badgeText: completed ? 'COMPLETED' : null,
          actionLabel: completed ? null : 'MARK AS DONE',
          connectorHeight: isLastMeal ? 74 : 92,
          isLast: false,
          onActionTap: completed ? null : () => onMealToggle(item),
        ),
      );

      if (index == 0) {
        entries.add(
          _ScheduleEntry(
            icon: Icons.monitor_weight_outlined,
            title: 'Weight Check-in',
            subtitle: 'Record today\'s weight progress',
            time: 'Anytime',
            state: _ScheduleState.active,
            actionLabel: 'RECORD WEIGHT',
            connectorHeight: mealEntries.length == 1 ? 74 : 92,
            onActionTap: () {
              Navigator.of(context).pushNamed(AppRoutes.weightCheckIn);
            },
          ),
        );
      }
    }

    if (entries.isEmpty) {
      entries.add(
        const _ScheduleEntry(
          icon: Icons.info_outline_rounded,
          title: 'No meals scheduled',
          subtitle: 'Save a plan in Plans to generate today\'s schedule.',
          time: '--',
          state: _ScheduleState.upcoming,
          isLast: true,
        ),
      );
    } else {
      final last = entries.removeLast();
      if (last is _ScheduleEntry) {
        entries.add(last.copyWith(isLast: true));
      }
    }

    return entries;
  }
}

enum _ScheduleState { completed, active, upcoming }

class _ScheduleEntry extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final _ScheduleState state;
  final String? badgeText;
  final String? actionLabel;
  final bool isLast;
  final double connectorHeight;
  final VoidCallback? onActionTap;

  const _ScheduleEntry({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.state,
    this.badgeText,
    this.actionLabel,
    this.isLast = false,
    this.connectorHeight = 74,
    this.onActionTap,
  });

  _ScheduleEntry copyWith({bool? isLast}) {
    return _ScheduleEntry(
      icon: icon,
      title: title,
      subtitle: subtitle,
      time: time,
      state: state,
      badgeText: badgeText,
      actionLabel: actionLabel,
      isLast: isLast ?? this.isLast,
      connectorHeight: connectorHeight,
      onActionTap: onActionTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isCompleted = state == _ScheduleState.completed;
    final isActive = state == _ScheduleState.active;
    final isUpcoming = state == _ScheduleState.upcoming;
    final muted = isUpcoming;

    final nodeFill = isCompleted || isActive
        ? primary.withValues(alpha: isCompleted ? 1 : 0.06)
        : primary.withValues(alpha: 0.08);
    final nodeBorder = isCompleted
        ? Colors.transparent
        : primary.withValues(alpha: isActive ? 0.9 : 0.18);
    final iconColor = isCompleted
        ? Colors.white
        : primary.withValues(alpha: isUpcoming ? 0.38 : 0.88);
    final lineColor = primary.withValues(alpha: 0.22);
    final cardColor = theme.brightness == Brightness.dark
        ? (isActive
              ? const Color(0xFF372027)
              : const Color(0xFF2B1A20).withValues(alpha: muted ? 0.7 : 1))
        : (isActive
              ? Colors.white
              : Colors.white.withValues(alpha: muted ? 0.42 : 0.76));
    final titleColor = muted
        ? theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.62)
        : theme.textTheme.titleLarge?.color;
    final subtitleColor = muted
        ? theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.76)
        : theme.textTheme.bodyMedium?.color;
    final timeColor = isActive
        ? primary
        : (muted
              ? theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.72)
              : theme.textTheme.bodyMedium?.color);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 84,
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: nodeFill,
                  shape: BoxShape.circle,
                  border: Border.all(color: nodeBorder, width: 3),
                ),
                child: Icon(icon, color: iconColor, size: 30),
              ),
              if (!isLast) ...[
                const SizedBox(height: 10),
                Container(
                  width: 6,
                  height: connectorHeight,
                  decoration: BoxDecoration(
                    color: lineColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 26),
            child: Container(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(28),
                border: isActive
                    ? Border.all(color: primary.withValues(alpha: 0.20))
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: theme.brightness == Brightness.dark ? 0.12 : 0.04,
                    ),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 120,
                          maxWidth: 220,
                        ),
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: titleColor,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: timeColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: subtitleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (badgeText != null) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppTheme.successGreen.withValues(alpha: 0.16),
                        ),
                      ),
                      child: Text(
                        badgeText!,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.successGreen,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                  if (actionLabel != null) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onActionTap,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          minimumSize: const Size(0, 56),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: Text(actionLabel!),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
