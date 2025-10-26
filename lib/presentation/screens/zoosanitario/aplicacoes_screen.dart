import 'package:flutter/material.dart';

class AplicacoesScreen extends StatelessWidget {
  const AplicacoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aplicações')),
      body: const Center(child: Text('Tela de Aplicações')),
    );
  }
}