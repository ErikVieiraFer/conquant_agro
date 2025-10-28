import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_drawer.dart';
import 'relatorios/relatorio_inventario.dart';
import 'relatorios/relatorio_movimentacoes.dart';
import 'relatorios/relatorio_custos.dart';
import 'relatorios/relatorio_sanitario.dart';

class RelatoriosScreen extends StatelessWidget {
  const RelatoriosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
      ),
      drawer: const CustomDrawer(),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildCardRelatorio(
            titulo: 'Inventário',
            icone: Icons.inventory,
            cor: Colors.blue,
            onTap: () => Get.to(() => const RelatorioInventario()),
          ),
          _buildCardRelatorio(
            titulo: 'Movimentações',
            icone: Icons.swap_horiz,
            cor: Colors.orange,
            onTap: () => Get.to(() => const RelatorioMovimentacoes()),
          ),
          _buildCardRelatorio(
            titulo: 'Custos',
            icone: Icons.attach_money,
            cor: Colors.red,
            onTap: () => Get.to(() => const RelatorioCustos()),
          ),
          _buildCardRelatorio(
            titulo: 'Sanitário',
            icone: Icons.medical_services,
            cor: Colors.green,
            onTap: () => Get.to(() => const RelatorioSanitario()),
          ),
        ],
      ),
    );
  }

  Widget _buildCardRelatorio({
    required String titulo,
    required IconData icone,
    required Color cor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 48, color: cor),
            const SizedBox(height: 12),
            Text(
              titulo,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
