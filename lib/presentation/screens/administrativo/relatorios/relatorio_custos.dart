import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/pdf_service.dart';
import '../../../controllers/financeiro_controller.dart';

class RelatorioCustos extends StatelessWidget {
  const RelatorioCustos({super.key});

  @override
  Widget build(BuildContext context) {
    final financeiroController = Get.find<FinanceiroController>();
    final formatCurrency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Custos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _gerarPDF(financeiroController, formatCurrency),
            tooltip: 'Gerar PDF',
          ),
        ],
      ),
      body: Obx(() {
        final despesas = financeiroController.despesas;

        if (despesas.isEmpty) {
          return const Center(
            child: Text('Nenhuma despesa registrada'),
          );
        }

        // Agrupar despesas por natureza
        final Map<String, double> custosPorNatureza = {};
        for (var despesa in despesas) {
          custosPorNatureza[despesa.natureza] =
            (custosPorNatureza[despesa.natureza] ?? 0) + despesa.valor;
        }

        final custosOrdenados = custosPorNatureza.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        final totalGeral = despesas.fold(0.0, (sum, d) => sum + d.valor);

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.red.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Geral:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formatCurrency.format(totalGeral),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: custosOrdenados.length,
                itemBuilder: (context, index) {
                  final item = custosOrdenados[index];
                  final percentual = (item.value / totalGeral * 100);

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red.shade100,
                        child: Text(
                          '${percentual.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                      title: Text(item.key),
                      trailing: Text(
                        formatCurrency.format(item.value),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _gerarPDF(
    FinanceiroController controller,
    NumberFormat formatCurrency,
  ) async {
    final despesas = controller.despesas;

    if (despesas.isEmpty) {
      Get.snackbar(
        'Aviso',
        'Não há dados para gerar o relatório',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Agrupar despesas por natureza
    final Map<String, double> custosPorNatureza = {};
    for (var despesa in despesas) {
      custosPorNatureza[despesa.natureza] =
        (custosPorNatureza[despesa.natureza] ?? 0) + despesa.valor;
    }

    final custosOrdenados = custosPorNatureza.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final totalGeral = despesas.fold(0.0, (sum, d) => sum + d.valor);

    final dados = custosOrdenados.map((item) {
      final percentual = (item.value / totalGeral * 100).toStringAsFixed(1);
      return [
        item.key,
        formatCurrency.format(item.value),
        '$percentual%',
      ];
    }).toList();

    // Adicionar linha de total
    dados.add(['TOTAL', formatCurrency.format(totalGeral), '100%']);

    await PdfService.gerarRelatorio(
      titulo: 'Relatório de Custos',
      subtitulo: 'Despesas agrupadas por natureza',
      colunas: ['Natureza', 'Valor', '% do Total'],
      dados: dados,
    );
  }
}
