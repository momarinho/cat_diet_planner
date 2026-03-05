import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/cat_selector_avatar.dart';

class HomeCatCarouselSection extends StatelessWidget {
  final void Function(CatProfile cat) onCatTap;

  const HomeCatCarouselSection({super.key, required this.onCatTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final now = DateTime.now();

    final milo = CatProfile(
      id: 'milo',
      name: 'Milo',
      weight: 4.5,
      age: 36,
      neutered: true,
      activityLevel: 'moderate',
      goal: 'maintenance',
      createdAt: now,
      photoPath:
          'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=200&q=80',
    );

    final luna = CatProfile(
      id: 'luna',
      name: 'Luna',
      weight: 4.2,
      age: 30,
      neutered: true,
      activityLevel: 'moderate',
      goal: 'maintenance',
      createdAt: now,
      photoPath:
          'https://images.unsplash.com/photo-1543852786-1cf6624b9987?auto=format&fit=crop&w=200&q=80',
    );

    final oliver = CatProfile(
      id: 'oliver',
      name: 'Oliver',
      weight: 5.0,
      age: 42,
      neutered: true,
      activityLevel: 'sedentary',
      goal: 'loss',
      createdAt: now,
      photoPath:
          'https://images.unsplash.com/photo-1573865526739-10659fec78a5?auto=format&fit=crop&w=200&q=80',
    );

    return SizedBox(
      height: 114,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CatSelectorAvatar(
              imagePath: milo.photoPath!,
              name: milo.name,
              isActive: true,
              onTap: () => onCatTap(milo),
            ),
            CatSelectorAvatar(
              imagePath: luna.photoPath!,
              name: luna.name,
              isActive: false,
              onTap: () => onCatTap(luna),
            ),
            CatSelectorAvatar(
              imagePath: oliver.photoPath!,
              name: oliver.name,
              isActive: false,
              onTap: () => onCatTap(oliver),
            ),
            const SizedBox(width: 8),
            Column(
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
                  'Add Cat',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: primary.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
