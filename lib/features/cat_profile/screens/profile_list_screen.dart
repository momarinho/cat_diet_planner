import 'package:flutter/material.dart';
import '../../../core/widgets/cat_selector_avatar.dart';

class ProfileListScreen extends StatelessWidget {
  const ProfileListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfis dos Gatos'), centerTitle: true),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CatSelectorAvatar(
              imagePath:
                  'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=200&q=80', // Gato laranja
              name: 'Milo',
              isActive: true,
              onTap: () {
                debugPrint('Milo Tocado');
              },
            ),
            CatSelectorAvatar(
              imagePath:
                  'https://images.unsplash.com/photo-1543852786-1cf6624b9987?auto=format&fit=crop&w=200&q=80', // Gato siamês
              name: 'Luna',
              isActive: false,
              onTap: () {
                debugPrint('Luna Tocada');
              },
            ),
            CatSelectorAvatar(
              imagePath:
                  'https://images.unsplash.com/photo-1573865526739-10659fec78a5?auto=format&fit=crop&w=200&q=80', // Gato cinza
              name: 'Oliver',
              isActive: false,
              onTap: () {
                debugPrint('Oliver Tocado');
              },
            ),
          ],
        ),
      ),
    );
  }
}
