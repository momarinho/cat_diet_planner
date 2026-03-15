import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/core/localization/app_formatters.dart';
import 'package:cat_diet_planner/core/theme/app_theme.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DailyScheduleSection extends StatelessWidget {
  const DailyScheduleSection({
    super.key,
    required this.schedule,
    required this.onMealToggle,
    this.showWeightCheckIn = true,
    this.title,
  });

  final List<Map<String, dynamic>> schedule;
  final ValueChanged<Map<String, dynamic>> onMealToggle;
  final bool showWeightCheckIn;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
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
              title ?? l10n.todaysScheduleTitle,
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
                AppFormatters.formatDate(context, DateTime.now()),
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
    final l10n = AppLocalizations.of(context);
    final entries = <Widget>[];
    final mealEntries = schedule;

    for (var index = 0; index < mealEntries.length; index++) {
      final item = mealEntries[index];
      final completed = item['completed'] == true;
      final type = item['type']?.toString() ?? 'meal';
      final mealContext = item['mealContext'] as String?;
      final notes = item['mealNotes'] as String?;
      final quantity = (item['quantity'] as num?)?.toDouble();
      final quantityUnit = item['quantityUnit']?.toString();
      final badge = _entryBadgeLabel(context, type, mealContext, completed);
      final contextualSubtitle = [
        _localizedSubtitle(context, item),
        if (type != 'meal' && quantity != null && quantity > 0)
          l10n
              .loggedQuantityLabel(
                quantity.toStringAsFixed(quantity % 1 == 0 ? 0 : 1),
                quantityUnit ?? '',
              )
              .trim(),
        if (notes != null && notes.trim().isNotEmpty)
          l10n.noteWithValueLabel(notes.trim()),
      ].where((line) => line.trim().isNotEmpty).join('\n');
      final isLastMeal = index == mealEntries.length - 1;

      entries.add(
        _ScheduleEntry(
          icon: completed ? Icons.check_rounded : Icons.restaurant_rounded,
          title: _localizedTitle(context, item),
          subtitle: contextualSubtitle,
          time: _localizedTime(context, item['time'] as String? ?? ''),
          state: completed ? _ScheduleState.completed : _ScheduleState.upcoming,
          badgeText: badge,
          actionLabel: completed
              ? l10n.updateLogAction
              : (type == 'meal' ? l10n.logMealAction : l10n.logEventAction),
          connectorHeight: isLastMeal ? 74 : 92,
          isLast: false,
          onActionTap: () => onMealToggle(item),
        ),
      );

      if (index == 0 && showWeightCheckIn) {
        entries.add(
          _ScheduleEntry(
            icon: Icons.monitor_weight_outlined,
            title: l10n.weightCheckInTitle,
            subtitle: l10n.recordTodaysWeightProgressDescription,
            time: l10n.anytimeLabel,
            state: _ScheduleState.active,
            actionLabel: l10n.recordWeightActionUppercase,
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
        _ScheduleEntry(
          icon: Icons.info_outline_rounded,
          title: l10n.noMealsScheduledTitle,
          subtitle: l10n.noMealsScheduledDescription,
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

  String _localizedTitle(BuildContext context, Map<String, dynamic> item) {
    final l10n = AppLocalizations.of(context);
    final type = item['type']?.toString() ?? 'meal';
    final rawTitle = item['title']?.toString().trim();
    if (type == 'water') return l10n.dailyWaterEntryTitle;
    if (type == 'snacks') return l10n.dailySnacksEntryTitle;
    if (type == 'supplements') return l10n.dailySupplementsEntryTitle;
    if (rawTitle == null || rawTitle.isEmpty) return l10n.genericMealTitle;
    return rawTitle;
  }

  String _localizedSubtitle(BuildContext context, Map<String, dynamic> item) {
    final l10n = AppLocalizations.of(context);
    final type = item['type']?.toString() ?? 'meal';
    final isGroup = (item['id']?.toString().startsWith('group_') ?? false);
    if (type == 'water') {
      return isGroup
          ? l10n.dailyWaterGroupSubtitle
          : l10n.dailyWaterCatSubtitle;
    }
    if (type == 'snacks') {
      return isGroup
          ? l10n.dailySnacksGroupSubtitle
          : l10n.dailySnacksCatSubtitle;
    }
    if (type == 'supplements') {
      return isGroup
          ? l10n.dailySupplementsGroupSubtitle
          : l10n.dailySupplementsCatSubtitle;
    }
    return item['subtitle'] as String? ?? '';
  }

  String _localizedTime(BuildContext context, String value) {
    final l10n = AppLocalizations.of(context);
    if (value.trim().isEmpty) return '';
    if (value.trim().toLowerCase() == 'anytime') return l10n.anytimeLabel;
    return AppFormatters.formatStoredMealTime(context, value);
  }

  String? _entryBadgeLabel(
    BuildContext context,
    String type,
    String? mealContext,
    bool completed,
  ) {
    final l10n = AppLocalizations.of(context);
    String upper(String value) => value.toUpperCase();
    if (type != 'meal') {
      switch (type) {
        case 'water':
          return completed
              ? upper(l10n.loggedStatus)
              : upper(l10n.dailyWaterEntryTitle);
        case 'snacks':
          return completed
              ? upper(l10n.loggedStatus)
              : upper(l10n.dailySnacksEntryTitle);
        case 'supplements':
          return completed
              ? upper(l10n.loggedStatus)
              : upper(l10n.dailySupplementsEntryTitle);
        default:
          return completed ? upper(l10n.loggedStatus) : upper(type);
      }
    }
    switch (mealContext) {
      case 'completed':
        return upper(l10n.completedOption);
      case 'partial':
        return upper(l10n.partialOption);
      case 'delayed':
        return upper(l10n.delayedOption);
      case 'refused':
        return upper(l10n.refusedOption);
      case 'reduced':
        return upper(l10n.reducedAppetiteOption);
      case 'skipped':
        return upper(l10n.skippedOption);
      default:
        return completed ? upper(l10n.completedOption) : null;
    }
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
