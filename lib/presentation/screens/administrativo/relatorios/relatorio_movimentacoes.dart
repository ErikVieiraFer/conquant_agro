import 'package:conquant_agro/presentation/controllers/movimentacao_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/pdf_service.dart';
import '../../../controllers/gado_controller.dart';
import '../../../controllers/pasto_controller.dart';

class RelatorioMovimentacoes extends StatelessWidget {
  const RelatorioMovimentacoes({super.key});

  @override
  Widget build(BuildContext context) {
    final gadoController = Get.find<GadoController>();
    final pastoController = Get.find<PastoController>();
    final movimentacaoController = Get.find<MovimentacaoController>();
    final formatDate = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Movimentações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () =>
                _gerarPDF(gadoController, pastoController, movimentacaoController, formatDate),
            tooltip: 'Gerar PDF',
          ),
        ],
      ),
      body: Obx(() {
        final movimentacoes = movimentacaoController.movimentacoes;
        final gados = gadoController.gados;
        final pastos = pastoController.pastos;

        if (movimentacoes.isEmpty) {
          return const Center(
            child: Text('Nenhuma movimentação registrada'),
          );
        }

        // Ordenar por data (mais recentes primeiro)
        final movimentacoesOrdenadas = movimentacoes.toList()
          ..sort((a, b) => b.data.compareTo(a.data));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: movimentacoesOrdenadas.length,
          itemBuilder: (context, index) {
            final mov = movimentacoesOrdenadas[index];
            final gado = gados.firstWhereOrNull((g) => g.id == mov.gadoId);
            final pastoOrigem =
                pastos.firstWhereOrNull((p) => p.id == mov.pastoOrigemId);
            final pastoDestino =
                pastos.firstWhereOrNull((p) => p.id == mov.pastoDestinoId);

            return Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.swap_horiz),
                ),
                title: Text('ID: ${gado?.idUsual ?? 'N/A'}'),
                subtitle: Text(
                  'De: ${pastoOrigem?.nome ?? 'N/A'}\nPara: ${pastoDestino?.nome ?? 'N/A'}',
                ),
                trailing: Text(
                  formatDate.format(mov.data),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Future<void> _gerarPDF(
    GadoController gadoController,
    PastoController pastoController,
    MovimentacaoController movimentacaoController,
    DateFormat format,
  ) async {
    final movimentacoes = movimentacaoController.movimentacoes;
    final gados = gadoController.gados;
    final pastos = pastoController.pastos;

    if (movimentacoes.isEmpty) {
      Get.snackbar(
        'Aviso',
        'Não há dados para gerar o relatório',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Ordenar por data (mais recentes primeiro)
    final movimentacoesOrdenadas = movimentacoes.toList()
      ..sort((a, b) => b.data.compareTo(a.data));

    final dados = movimentacoesOrdenadas.map((mov) {
      final gado = gados.firstWhereOrNull((g) => g.id == mov.gadoId);
      final pastoOrigem =
          pastos.firstWhereOrNull((p) => p.id == mov.pastoOrigemId);
      final pastoDestino =
          pastos.firstWhereOrNull((p) => p.id == mov.pastoDestinoId);

      return [
        format.format(mov.data),
        gado?.idUsual ?? 'N/A',
        pastoOrigem?.nome ?? 'N/A',
        pastoDestino?.nome ?? 'N/A',
      ];
    }).toList();

    await PdfService.gerarRelatorio(
      titulo: 'Relatório de Movimentações',
      subtitulo: 'Total de movimentações: ${movimentacoes.length}',
      colunas: ['Data', 'Brinco', 'Pasto Origem', 'Pasto Destino'],
      dados: dados,
    );
  }
}
