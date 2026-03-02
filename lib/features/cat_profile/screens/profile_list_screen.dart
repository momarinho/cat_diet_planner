import 'package:cat_diet_planner/core/widgets/ghost_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/cat_selector_avatar.dart';

import '../../../core/widgets/neon_button.dart';

class ProfileListScreen extends ConsumerWidget {
  const ProfileListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CatDiet Planner'),
        centerTitle: true,
        // Adicionando aquele sininho do design original!
        actions: [
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

      // O Segredo: Uma SingleChildScrollView permite rolar a tela se o celular for pequeno
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
            24.0,
          ), // Margem de respiro de toda a tela
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinha tudo à esquerda (Start)
            children: [
              // 1. A SEÇÃO DOS GATINHOS
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CatSelectorAvatar(
                      imagePath:
                          'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=200&q=80',
                      name: 'Milo',
                      isActive: true,
                      onTap: () => debugPrint('Milo'),
                    ),
                    const SizedBox(width: 16), // Espaçamento entre os gatos
                    CatSelectorAvatar(
                      imagePath:
                          'https://images.unsplash.com/photo-1543852786-1cf6624b9987?auto=format&fit=crop&w=200&q=80',
                      name: 'Luna',
                      isActive: false,
                      onTap: () => debugPrint('Luna'),
                    ),
                    const SizedBox(width: 16),
                    CatSelectorAvatar(
                      imagePath:
                          'https://images.unsplash.com/photo-1573865526739-10659fec78a5?auto=format&fit=crop&w=200&q=80',
                      name: 'Oliver',
                      isActive: false,
                      onTap: () => debugPrint('Oliver'),
                    ),
                    const SizedBox(width: 16),
                    // O Botão de "+" (Add New) do Stitch!
                    _buildAddCatButton(context),
                  ],
                ),
              ),

              const SizedBox(height: 48), // Espaço grande em branco
              // 2. A SEÇÃO DE TESTE DO BOTÃO NEON
              const Text(
                'Playground de Botões',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Aqui está o seu NeonButton brilhando!
              NeonButton(
                text: '🍴 Feed Now',
                onTap: () {
                  debugPrint('Alimentando o Milo!');
                },
              ),

              const SizedBox(height: 24),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GhostButton(
                      text: 'Scan Food',
                      icon: Icons.qr_code_scanner,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GhostButton(
                      text: 'Log Weight',
                      icon: Icons.monitor_weight_outlined,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET AUXILIAR ---
  // Aquele círculo pontilhado com um "+" dentro para adicionar gato
  Widget _buildAddCatButton(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(
                0.3,
              ), // Borda cinza/translúcida
              width: 1.5,
              style: BorderStyle
                  .none, // O Flutter puro não tem borda pontilhada nativa
            ),
            // Simulando a borda do design com uma cor de fundo sutil
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
          ),
        ),
      ],
    );
  }
}
