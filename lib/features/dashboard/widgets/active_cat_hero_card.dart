import 'package:flutter/material.dart';

import 'package:cat_diet_planner/data/models/cat_profile.dart';
import '../../../core/widgets/app_card_container.dart';

class ActiveCatHeroCard extends StatelessWidget {
  final CatProfile cat;
  const ActiveCatHeroCard({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return AppCardContainer(
      child: Column(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(cat.photoPath ?? '')),
          Text(cat.name),
          Text(
            '${cat.weight.toStringAsFixed(1)} kg • ${cat.age ~/ 12} Years Old',
          ),
        ],
      ),
    );
  }
}
