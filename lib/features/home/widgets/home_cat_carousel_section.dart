import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/cat_profiles_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/cat_selector_avatar.dart';

class HomeCatCarouselSection extends ConsumerWidget {
  final void Function(CatProfile cat) onCatTap;
  final VoidCallback onAddCatTap;

  const HomeCatCarouselSection({
    super.key,
    required this.onCatTap,
    required this.onAddCatTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = Theme.of(context).colorScheme.primary;
    final selectedCat = ref.watch(selectedCatProvider);
    final cats = ref.watch(catProfilesProvider);

    return SizedBox(
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
                onTap: () {
                  ref.read(selectedCatProvider.notifier).state = cat;
                  onCatTap(cat);
                },
              );
            }),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onAddCatTap,
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    );
  }
}
