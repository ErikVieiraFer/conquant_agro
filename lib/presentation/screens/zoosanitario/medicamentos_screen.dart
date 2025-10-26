import 'package:flutter/material.dart';

class MedicamentosScreen extends StatelessWidget {
  const MedicamentosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medicamentos')),
      body: const Center(child: Text('Tela de Medicamentos')),
    );
  }
}