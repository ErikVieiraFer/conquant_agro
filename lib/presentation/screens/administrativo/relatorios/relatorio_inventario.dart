import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/pdf_service.dart';
import '../../../controllers/gado_controller.dart';

class RelatorioInventario extends StatelessWidget {
  const RelatorioInventario({super.key});

  @override
  Widget build(BuildContext context) {
    final gadoController = Get.find<GadoController>();
    final formatDate = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Inventário'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _gerarPDF(gadoController, formatDate),
            tooltip: 'Gerar PDF',
          ),
        ],
      ),
      body: Obx(() {
        final gados = gadoController.gados;

        if (gados.isEmpty) {
          return const Center(
            child: Text('Nenhum animal cadastrado'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: gados.length,
          itemBuilder: (context, index) {
            final gado = gados[index];
            final idade = _calcularIdade(gado.dataNascimento);

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(gado.idUsual.substring(0, 1)),
                ),
                title: Text('ID: ${gado.idUsual}'),
                subtitle: Text('Raça: ${gado.raca}\nIdade: $idade'),
                trailing: Text(
                  formatDate.format(gado.dataNascimento),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  String _calcularIdade(DateTime dataNascimento) {
    final hoje = DateTime.now();
    final diferenca = hoje.difference(dataNascimento);
    final meses = (diferenca.inDays / 30).floor();

    if (meses < 12) {
      return '$meses meses';
    } else {
      final anos = (meses / 12).floor();
      final mesesRestantes = meses % 12;
      if (mesesRestantes == 0) {
        return '$anos ${anos == 1 ? 'ano' : 'anos'}';
      }
      return '$anos ${anos == 1 ? 'ano' : 'anos'} e $mesesRestantes ${mesesRestantes == 1 ? 'mês' : 'meses'}';
    }
  }

  Future<void> _gerarPDF(GadoController controller, DateFormat format) async {
    final gados = controller.gados;

    if (gados.isEmpty) {
      Get.snackbar(
        'Aviso',
        'Não há dados para gerar o relatório',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final dados = gados.map((g) => [
      g.idUsual,
      g.raca,
      format.format(g.dataNascimento),
      _calcularIdade(g.dataNascimento),
    ]).toList();

    await PdfService.gerarRelatorio(
      titulo: 'Relatório de Inventário',
      subtitulo: 'Total de animais: ${gados.length}',
      colunas: ['ID', 'Raça', 'Data Nascimento', 'Idade'],
      dados: dados,
    );
  }
}
