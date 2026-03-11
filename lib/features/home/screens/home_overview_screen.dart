// lib/features/home/screens/home_overview_screen.dart
import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/home_cat_carousel_section.dart';
import '../widgets/home_header_app_bar.dart';
import '../widgets/home_health_insights_card.dart';
import '../widgets/home_health_stats_grid.dart';
import '../widgets/home_next_feeding_card.dart';

class HomeOverviewScreen extends ConsumerWidget {
  const HomeOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCat = ref.watch(selectedCatProvider);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.70) ??
        const Color(0xFF7A7678);

    return Scaffold(
      appBar: const HomeHeaderAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        child: Column(
          children: [
            HomeCatCarouselSection(
              onCatTap: (cat) {
                Navigator.of(
                  context,
                ).pushNamed(AppRoutes.dashboard, arguments: cat);
              },
            ),
            if (selectedCat != null) ...[
              const SizedBox(height: 12),
              Container(
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
                child: Row(
                  children: [
                    Icon(Icons.pets_rounded, color: primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Active profile: ${selectedCat.name}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      '${selectedCat.weight.toStringAsFixed(1)} kg',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: secondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            const HomeNextFeedingCard(),
            const SizedBox(height: 16),
            const HomeHealthInsightsCard(),
            const SizedBox(height: 16),
            const HomeHealthStatsGrid(),
          ],
        ),
      ),
    );
  }
}
