import 'package:flutter/material.dart';

class PropriedadesScreen extends StatelessWidget {
  const PropriedadesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Propriedades')),
      body: const Center(child: Text('Tela de Propriedades')),
    );
  }
}