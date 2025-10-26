import 'package:flutter/material.dart';

class GadosScreen extends StatelessWidget {
  const GadosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gados')),
      body: const Center(child: Text('Tela de Gados')),
    );
  }
}