import 'package:flutter/material.dart';

class MovimentacoesScreen extends StatelessWidget {
  const MovimentacoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movimentações')),
      body: const Center(child: Text('Tela de Movimentações')),
    );
  }
}