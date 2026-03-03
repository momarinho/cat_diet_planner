import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/cat_selector_avatar.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/ghost_button.dart';
import '../../../core/widgets/app_card_container.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/meal_horizontal_card.dart';
import '../../../core/widgets/daily_summary_ring.dart';
import '../../../core/widgets/vertical_timeline_tile.dart';

class ProfileListScreen extends ConsumerWidget {
  const ProfileListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Components Showcase'),
        centerTitle: true,
        actions: [
          // Botão mágico de trocar tema Claro/Escuro
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================
            // SEÇÃO 1: AVATARES DE GATOS
            // ============================================
            const _SectionTitle(title: '1. Cat Avatars'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CatSelectorAvatar(
                    imagePath:
                        'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=200&q=80',
                    name: 'Milo',
                    isActive: true,
                    onTap: () => debugPrint('Milo Tocado'),
                  ),
                  CatSelectorAvatar(
                    imagePath:
                        'https://images.unsplash.com/photo-1543852786-1cf6624b9987?auto=format&fit=crop&w=200&q=80',
                    name: 'Luna',
                    isActive: false,
                    onTap: () => debugPrint('Luna Tocada'),
                  ),
                  CatSelectorAvatar(
                    imagePath:
                        'https://images.unsplash.com/photo-1573865526739-10659fec78a5?auto=format&fit=crop&w=200&q=80',
                    name: 'Oliver',
                    isActive: false,
                    onTap: () => debugPrint('Oliver Tocado'),
                  ),
                  const SizedBox(width: 8),
                  _buildAddCatButton(context),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ============================================
            // SEÇÃO 2: CARDS & STATUS BADGES
            // ============================================
            const _SectionTitle(title: '2. App Card & Badges'),
            AppCardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Health Status',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      // BADGE ALERTA/ROSA
                      const StatusBadge(
                        text: '45 MIN LEFT',
                        baseColor: AppTheme.primaryNeon,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Milo is currently on track with his daily goals! Here are some sample tags showing different statuses.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      // BADGE ROSA
                      StatusBadge(
                        text: 'Active',
                        baseColor: AppTheme.primaryNeon,
                      ),
                      SizedBox(width: 8),
                      // BADGE VERDE
                      StatusBadge(
                        text: 'Completed',
                        baseColor: AppTheme.successGreen,
                      ),
                      SizedBox(width: 8),
                      // BADGE AMARELO
                      StatusBadge(
                        text: 'Warning',
                        baseColor: AppTheme.warningYellow,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ============================================
            // SEÇÃO 3: BOTÕES NEON E GHOST
            // ============================================
            const _SectionTitle(title: '3. Action Buttons'),
            // BOTÃO PRINCIPAL
            NeonButton(
              text: '🍴 Feed Now',
              onTap: () => debugPrint('Feed Now Apertado'),
            ),
            const SizedBox(height: 16),
            // BOTÕES VAZADOS (LADO A LADO)
            Row(
              children: [
                Expanded(
                  child: GhostButton(
                    text: 'Scan Food',
                    icon: Icons.qr_code_scanner,
                    onTap: () => debugPrint('Scan Food'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GhostButton(
                    text: 'Log Weight',
                    icon: Icons.monitor_weight_outlined,
                    onTap: () => debugPrint('Log Weight'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // ============================================
            // SEÇÃO 4: MEAL TIMELINE (HORIZONTAL)
            // ============================================
            const _SectionTitle(title: '4. Meal Timeline'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  const MealHorizontalCard(
                    title: 'Breakfast',
                    time: '08:00 AM',
                    calories: 100,
                    icon: Icons.breakfast_dining,
                    isCompleted: true,
                  ),
                  const SizedBox(width: 16),
                  const MealHorizontalCard(
                    title: 'Lunch',
                    time: '01:00 PM',
                    calories: 150,
                    icon: Icons.lunch_dining,
                    isCompleted: true,
                  ),
                  const SizedBox(width: 16),
                  const MealHorizontalCard(
                    title: 'Dinner',
                    time: '07:00 PM',
                    calories: 150,
                    icon: Icons.dinner_dining,
                    isNext: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // ============================================
            // SEÇÃO 5: DAILY SUMMARY + VERTICAL TIMELINE
            // ============================================
            const _SectionTitle(title: '5. Daily Summary & Vertical Timeline'),
            AppCardContainer(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DailySummaryRing(
                    consumedCalories: 250,
                    goalCalories: 300,
                    size: 110,
                    strokeWidth: 10,
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Column(
                      children: [
                        VerticalTimelineTile(
                          icon: Icons.breakfast_dining,
                          title: 'Breakfast',
                          subtitle: '08:00 AM • 100 kcal',
                        ),
                        VerticalTimelineTile(
                          icon: Icons.lunch_dining,
                          title: 'Lunch',
                          subtitle: '01:00 PM • 150 kcal',
                        ),
                        VerticalTimelineTile(
                          icon: Icons.dinner_dining,
                          title: 'Dinner',
                          subtitle: '07:00 PM • 150 kcal',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48), // Espaço final
          ],
        ),
      ),
    );
  }

  // --- WIDGET AUXILIAR DO ADD NEW ---
  Widget _buildAddCatButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                width: 1.5,
                style: BorderStyle.none,
              ),
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            ),
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add New',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Minimal Widget just to render nice titles in this showcase
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
