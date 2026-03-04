import 'package:flutter/material.dart';

import '../../../core/widgets/meal_horizontal_card.dart';

class DashboardMealTimelineSection extends StatelessWidget {
  const DashboardMealTimelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Meal Timeline',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Text(
              'View Plan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: const [
              MealHorizontalCard(
                title: 'Breakfast',
                time: '08:00 AM',
                calories: 100,
                icon: Icons.breakfast_dining,
                isCompleted: true,
              ),
              SizedBox(width: 12),
              MealHorizontalCard(
                title: 'Lunch',
                time: '01:00 PM',
                calories: 150,
                icon: Icons.lunch_dining,
                isCompleted: true,
              ),
              SizedBox(width: 12),
              MealHorizontalCard(
                title: 'Dinner',
                time: '07:00 PM',
                calories: 150,
                icon: Icons.dinner_dining,
                isNext: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
