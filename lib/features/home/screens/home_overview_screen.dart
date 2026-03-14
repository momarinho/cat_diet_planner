import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/cat_profiles_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:cat_diet_planner/features/home/providers/home_summary_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/home_cat_carousel_section.dart';
import '../widgets/home_groups_section.dart';
import '../widgets/home_header_app_bar.dart';
import '../widgets/home_health_insights_card.dart';
import '../widgets/home_health_stats_grid.dart';
import '../widgets/home_next_feeding_card.dart';

class HomeOverviewScreen extends ConsumerWidget {
  const HomeOverviewScreen({super.key});

  void _openCatProfile(BuildContext context, Object? cat) {
    Navigator.of(context).pushNamed(AppRoutes.catProfile, arguments: cat);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cats = ref.watch(catProfilesProvider);
    final selectedCat = ref.watch(selectedCatProvider);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.70) ??
        const Color(0xFF7A7678);
    final summary = ref.watch(homeSummaryProvider);

    return Scaffold(
      appBar: const HomeHeaderAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        child: Column(
          children: [
            HomeCatCarouselSection(
              onAddCatTap: () {
                Navigator.of(context).pushNamed(AppRoutes.catProfile);
              },
              onCatTap: (cat) {
                Navigator.of(
                  context,
                ).pushNamed(AppRoutes.dashboard, arguments: cat);
              },
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 380;
                final profileButton = OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.catProfile);
                  },
                  icon: const Icon(Icons.pets_outlined),
                  label: const Text('New Profile'),
                );
                final groupButton = FilledButton.tonalIcon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.catGroup);
                  },
                  icon: const Icon(Icons.groups_outlined),
                  label: const Text('New Group'),
                );

                if (narrow) {
                  return Column(
                    children: [
                      SizedBox(width: double.infinity, child: profileButton),
                      const SizedBox(height: 12),
                      SizedBox(width: double.infinity, child: groupButton),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: profileButton),
                    const SizedBox(width: 12),
                    Expanded(child: groupButton),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            const HomeGroupsSection(),
            if (cats.isEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primary.withValues(alpha: 0.10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No cat profiles yet',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Create your first cat profile to unlock plans, weight check-ins, and reports.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: secondary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    FilledButton.icon(
                      onPressed: () {
                        _openCatProfile(context, null);
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Create First Profile'),
                    ),
                  ],
                ),
              ),
            ],
            if (selectedCat != null) ...[
              const SizedBox(height: 12),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  _openCatProfile(context, selectedCat);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primary.withValues(alpha: 0.10)),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final narrow = constraints.maxWidth < 420;

                      final info = Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Active profile: ${selectedCat.name}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap to edit this cat profile',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );

                      final trailing = narrow
                          ? Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                FilledButton.tonalIcon(
                                  onPressed: () =>
                                      _openCatProfile(context, selectedCat),
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                  ),
                                  label: const Text('Edit'),
                                ),
                                Text(
                                  '${selectedCat.weight.toStringAsFixed(1)} kg',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: secondary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FilledButton.tonalIcon(
                                  onPressed: () =>
                                      _openCatProfile(context, selectedCat),
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                  ),
                                  label: const Text('Edit'),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${selectedCat.weight.toStringAsFixed(1)} kg',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: secondary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            );

                      if (narrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.pets_rounded,
                                  color: primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                info,
                              ],
                            ),
                            const SizedBox(height: 12),
                            trailing,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.pets_rounded, color: primary, size: 20),
                          const SizedBox(width: 10),
                          info,
                          const SizedBox(width: 12),
                          trailing,
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            HomeNextFeedingCard(summary: summary),
            const SizedBox(height: 16),
            HomeHealthInsightsCard(summary: summary),
            const SizedBox(height: 16),
            HomeHealthStatsGrid(summary: summary),
          ],
        ),
      ),
    );
  }
}
