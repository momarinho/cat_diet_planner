import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/data/models/group_diet_plan.dart';
import 'package:cat_diet_planner/features/cat_group/providers/selected_group_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/cat_groups_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/cat_profiles_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:cat_diet_planner/features/daily/services/daily_meal_schedule_service.dart';
import 'package:cat_diet_planner/features/settings/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeGroupsSection extends ConsumerWidget {
  const HomeGroupsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(catGroupsProvider);
    if (groups.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ??
        const Color(0xFF7A7678);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Groups',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Text(
              '${groups.length} active',
              style: theme.textTheme.bodySmall?.copyWith(
                color: secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...groups.map(
          (group) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _GroupCard(group: group, primary: primary),
          ),
        ),
      ],
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group, required this.primary});

  final CatGroup group;
  final Color primary;

  IconData _groupIcon(String? iconName) {
    switch (iconName) {
      case 'pets':
        return Icons.pets_rounded;
      case 'home_work':
        return Icons.home_work_outlined;
      case 'grass':
        return Icons.grass_rounded;
      case 'shield_moon':
        return Icons.shield_moon_outlined;
      case 'groups':
      default:
        return Icons.groups_2_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ??
        const Color(0xFF7A7678);

    return Consumer(
      builder: (context, ref, _) {
        final catProfiles = ref.watch(catProfilesProvider);
        final selectedGroup = ref.watch(selectedGroupProvider);
        final isActive = selectedGroup?.id == group.id;
        final linkedCats = catProfiles
            .where((cat) => group.catIds.contains(cat.id))
            .map((cat) => cat.name)
            .toList(growable: false);
        final icon = _groupIcon(group.iconName);
        final accent = group.secondaryColorValue == null
            ? Color(group.colorValue)
            : Color(group.secondaryColorValue!);

        return LayoutBuilder(
          builder: (context, constraints) {
            final narrow = constraints.maxWidth < 420;
            final actions = narrow
                ? Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.tonal(
                        onPressed: () async {
                          ref.read(selectedCatProvider.notifier).state = null;
                          ref.read(selectedGroupProvider.notifier).state =
                              group;
                          await NotificationService.setActiveGroupContext(
                            groupId: group.id,
                            groupName: group.name,
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${group.name} is now active in Daily.',
                              ),
                            ),
                          );
                        },
                        child: const Text('Use Today'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.catGroup, arguments: group);
                        },
                        child: const Text('Edit'),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      FilledButton.tonal(
                        onPressed: () async {
                          ref.read(selectedCatProvider.notifier).state = null;
                          ref.read(selectedGroupProvider.notifier).state =
                              group;
                          await NotificationService.setActiveGroupContext(
                            groupId: group.id,
                            groupName: group.name,
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${group.name} is now active in Daily.',
                              ),
                            ),
                          );
                        },
                        child: const Text('Use Today'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.catGroup, arguments: group);
                        },
                        child: const Text('Edit'),
                      ),
                    ],
                  );

            final info = Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    linkedCats.isNotEmpty
                        ? '${linkedCats.length} linked cat(s)'
                        : '${group.catCount} cat(s) in this group',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: secondary,
                    ),
                  ),
                  if (linkedCats.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      linkedCats.join(' • '),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if ((group.description ?? '').isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      group.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: secondary,
                      ),
                    ),
                  ],
                  if ((group.subgroup ?? '').isNotEmpty ||
                      (group.category ?? '').isNotEmpty ||
                      (group.enclosure ?? '').isNotEmpty ||
                      (group.environment ?? '').isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if ((group.subgroup ?? '').isNotEmpty)
                          _StatusPill(
                            text: 'Subgroup: ${group.subgroup}',
                            color: accent,
                          ),
                        if ((group.category ?? '').isNotEmpty)
                          _StatusPill(
                            text: 'Category: ${group.category}',
                            color: accent,
                          ),
                        if ((group.enclosure ?? '').isNotEmpty)
                          _StatusPill(
                            text: 'Enclosure: ${group.enclosure}',
                            color: accent,
                          ),
                        if ((group.environment ?? '').isNotEmpty)
                          _StatusPill(
                            text: 'Environment: ${group.environment}',
                            color: accent,
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  ValueListenableBuilder(
                    valueListenable: HiveService.groupDietPlansBox.listenable(
                      keys: [group.id],
                    ),
                    builder: (context, Box<GroupDietPlan> box, _) {
                      final plan = box.get(group.id);
                      if (plan == null) {
                        return Text(
                          'No group plan yet',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: secondary,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      }

                      final schedule =
                          DailyMealScheduleService.loadTodayForGroup(
                            group.id,
                          ) ??
                          DailyMealScheduleService.ensureTodayGroupSchedule(
                            group: group,
                            plan: plan,
                          );
                      final completed =
                          DailyMealScheduleService.completedMealsCount(
                            schedule,
                          );
                      final total = DailyMealScheduleService.totalMealsCount(
                        schedule,
                      );

                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _StatusPill(
                            text:
                                '${plan.targetKcalPerGroupPerDay.toStringAsFixed(0)} kcal/day',
                            color: primary,
                          ),
                          _StatusPill(
                            text: '$completed/$total meals done',
                            color: completed == total && total > 0
                                ? Colors.green
                                : const Color(0xFFFFB347),
                          ),
                        ],
                      );
                    },
                  ),
                  if (isActive) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Active in Daily',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            );

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? primary : primary.withValues(alpha: 0.1),
                  width: isActive ? 2 : 1,
                ),
              ),
              child: narrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: Color(
                                group.colorValue,
                              ).withValues(alpha: 0.2),
                              child: Icon(icon, color: Color(group.colorValue)),
                            ),
                            const SizedBox(width: 12),
                            info,
                          ],
                        ),
                        const SizedBox(height: 12),
                        actions,
                      ],
                    )
                  : Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(
                            group.colorValue,
                          ).withValues(alpha: 0.2),
                          child: Icon(icon, color: Color(group.colorValue)),
                        ),
                        const SizedBox(width: 12),
                        info,
                        const SizedBox(width: 12),
                        actions,
                      ],
                    ),
            );
          },
        );
      },
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
