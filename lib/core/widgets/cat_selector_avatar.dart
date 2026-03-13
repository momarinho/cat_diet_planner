import 'package:cat_diet_planner/core/utils/cat_photo.dart';
import 'package:flutter/material.dart';

class CatSelectorAvatar extends StatelessWidget {
  final String? imagePath;
  final String? photoBase64;
  final String name;
  final bool isActive;
  final VoidCallback onTap;

  const CatSelectorAvatar({
    super.key,
    this.imagePath,
    this.photoBase64,
    required this.name,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Pegamos tokens de cor do nosso AppTheme
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Ocupa o menor espaço vertical possível
          children: [
            // 2. Uso do STACK para colocar o círculo "check" por cima da foto
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                // 3. A FOTO (com ou sem glow brilhante)
                Container(
                  width: isActive ? 72 : 56, // Cresce se estiver ativo
                  height: isActive ? 72 : 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // O contorno neon caso ativo!
                    border: isActive
                        ? Border.all(color: colorScheme.primary, width: 2)
                        : null,
                    // O brilho esparramado rosa claro!
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                    image: DecorationImage(
                      image: catPhotoProvider(
                        photoPath: imagePath,
                        photoBase64: photoBase64,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // 4. A BOLINHA DE CHECK (apenas se for o gato ativo)
                if (isActive)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: colorScheme
                          .surface, // Puxa fundo da tela (para criar "recorte")
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // 5. O NOME ABAIXO DA FOTO (Rosa escurecido se inativo)
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
