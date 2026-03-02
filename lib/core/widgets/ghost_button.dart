import 'package:flutter/material.dart';

class GhostButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const GhostButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Acessamos a cor primária (Rosa Neon) do nosso tema
    final colorScheme = Theme.of(context).colorScheme;

    // OutlinedButton é o componente nativo perfeito para "Ghost Buttons"
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: colorScheme.primary, size: 20),
      label: Text(
        text,
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      style: OutlinedButton.styleFrom(
        // Fundo transparente para mostrar o dark/light mode por trás
        backgroundColor: Colors.transparent,

        // A borda rosa
        side: BorderSide(color: colorScheme.primary, width: 1.5),

        // O formato de Pílula exato do design
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),

        // Garante a altura de 56px para bater com a altura do NeonButton
        minimumSize: const Size(0, 56),
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
    );
  }
}
