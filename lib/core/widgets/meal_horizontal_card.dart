import 'package:flutter/material.dart';

class MealHorizontalCard extends StatelessWidget {
  final String title;
  final String time;
  final int calories;
  final IconData icon;
  final bool isCompleted;
  final bool isNext;

  const MealHorizontalCard({
    super.key,
    required this.title,
    required this.time,
    required this.calories,
    required this.icon,
    this.isCompleted = false,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Destaca o fundo se for a próxima refeição no modo escuro
        color: isNext && isDark
            ? colorScheme.primary.withValues(alpha: 0.1)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        // Borda mais espessa e sólida para a refeição em destaque
        border: Border.all(
          color: isNext
              ? colorScheme.primary
              : colorScheme.primary.withValues(alpha: 0.2),
          width: isNext ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: colorScheme.primary, size: 24),
              // Indicador de status (concluído ou pendente)
              Icon(
                isCompleted ? Icons.check_circle : Icons.pending,
                color: isCompleted
                    ? const Color(0xFF4ADE80)
                    : colorScheme.onSurface.withValues(alpha: 0.3),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            time,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$calories kcal',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
