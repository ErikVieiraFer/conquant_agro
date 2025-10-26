import 'package:flutter/material.dart';

class DashboardProducao extends StatelessWidget {
  const DashboardProducao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard de Produção')),
      body: const Center(child: Text('Dashboard de Produção')),
    );
  }
}