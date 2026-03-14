import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/features/cat_group/providers/selected_group_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/cat_profiles_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:cat_diet_planner/features/settings/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/cat_selector_avatar.dart';

class HomeCatCarouselSection extends ConsumerStatefulWidget {
  final void Function(CatProfile cat) onCatTap;
  final VoidCallback onAddCatTap;

  const HomeCatCarouselSection({
    super.key,
    required this.onCatTap,
    required this.onAddCatTap,
  });

  @override
  ConsumerState<HomeCatCarouselSection> createState() =>
      _HomeCatCarouselSectionState();
}

class _HomeCatCarouselSectionState
    extends ConsumerState<HomeCatCarouselSection> {
  bool _showListView = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final selectedCat = ref.watch(selectedCatProvider);
    final cats = ref.watch(catProfilesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Cats',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            if (cats.length > 4)
              TextButton.icon(
                onPressed: () {
                  setState(() => _showListView = !_showListView);
                },
                icon: Icon(
                  _showListView
                      ? Icons.view_carousel_rounded
                      : Icons.view_list_rounded,
                ),
                label: Text(_showListView ? 'Carousel' : 'List'),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          cats.isEmpty
              ? 'No cat profiles yet'
              : '${cats.length} cat(s) visible',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        if (_showListView && cats.isNotEmpty)
          Column(
            children: [
              ...cats.map((cat) {
                final isActive = selectedCat?.id == cat.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      ref.read(selectedGroupProvider.notifier).state = null;
                      ref.read(selectedCatProvider.notifier).state = cat;
                      await NotificationService.setActiveCatContext(
                        catId: cat.id,
                        catName: cat.name,
                      );
                      if (!mounted) return;
                      widget.onCatTap(cat);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive
                              ? primary
                              : primary.withValues(alpha: 0.1),
                          width: isActive ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CatSelectorAvatar(
                            imagePath: cat.photoPath,
                            photoBase64: cat.photoBase64,
                            name: cat.name,
                            isActive: isActive,
                            onTap: () async {
                              ref.read(selectedGroupProvider.notifier).state =
                                  null;
                              ref.read(selectedCatProvider.notifier).state =
                                  cat;
                              await NotificationService.setActiveCatContext(
                                catId: cat.id,
                                catName: cat.name,
                              );
                              if (!mounted) return;
                              widget.onCatTap(cat);
                            },
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cat.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${cat.weight.toStringAsFixed(1)} kg • ${catGoalLabel(cat.goal)}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.textTheme.bodyMedium?.color
                                        ?.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: widget.onAddCatTap,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(cats.isEmpty ? 'Add First Cat' : 'Add Cat'),
                ),
              ),
            ],
          )
        else
          SizedBox(
            height: 114,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...cats.map((cat) {
                    final isActive = selectedCat?.id == cat.id;

                    return CatSelectorAvatar(
                      imagePath: cat.photoPath,
                      photoBase64: cat.photoBase64,
                      name: cat.name,
                      isActive: isActive,
                      onTap: () async {
                        ref.read(selectedGroupProvider.notifier).state = null;
                        ref.read(selectedCatProvider.notifier).state = cat;
                        await NotificationService.setActiveCatContext(
                          catId: cat.id,
                          catName: cat.name,
                        );
                        if (!mounted) return;
                        widget.onCatTap(cat);
                      },
                    );
                  }),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: widget.onAddCatTap,
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primary.withValues(alpha: 0.55),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.add, color: primary, size: 28),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cats.isEmpty ? 'Add First Cat' : 'Add Cat',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: primary.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
