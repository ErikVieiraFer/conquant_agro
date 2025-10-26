import 'package:flutter/material.dart';

class PesagemScreen extends StatelessWidget {
  const PesagemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesagem')),
      body: const Center(child: Text('Tela de Pesagem')),
    );
  }
}