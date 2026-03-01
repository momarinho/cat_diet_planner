import 'package:flutter/material.dart';

class ProfileListScreen extends StatelessWidget {
  const ProfileListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfis dos Gatos'), centerTitle: true),
      body: const Center(child: Text('Nenhum gatinho cadastrado ainda.')),
    );
  }
}
