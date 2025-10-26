import 'package:flutter/material.dart';

class PastosScreen extends StatelessWidget {
  const PastosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pastos')),
      body: const Center(child: Text('Tela de Pastos')),
    );
  }
}