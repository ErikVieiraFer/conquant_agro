import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/pdf_service.dart';

// Mock de aplicações sanitárias para demonstração
class AplicacaoSanitaria {
  final String id;
  final String gadoBrinco;
  final String medicamentoNome;
  final DateTime dataAplicacao;
  final int carenciaDias;

  AplicacaoSanitaria({
    required this.id,
    required this.gadoBrinco,
    required this.medicamentoNome,
    required this.dataAplicacao,
    required this.carenciaDias,
  });

  DateTime get dataLiberacao => dataAplicacao.add(Duration(days: carenciaDias));

  bool get emCarencia => DateTime.now().isBefore(dataLiberacao);

  int get diasRestantes {
    if (!emCarencia) return 0;
    return dataLiberacao.difference(DateTime.now()).inDays;
  }
}

class RelatorioSanitario extends StatelessWidget {
  const RelatorioSanitario({super.key});

  // Dados mockados para demonstração
  static final List<AplicacaoSanitaria> _aplicacoesMock = [
    AplicacaoSanitaria(
      id: '1',
      gadoBrinco: 'BRC001',
      medicamentoNome: 'Ivermectina',
      dataAplicacao: DateTime.now().subtract(const Duration(days: 5)),
      carenciaDias: 14,
    ),
    AplicacaoSanitaria(
      id: '2',
      gadoBrinco: 'BRC002',
      medicamentoNome: 'Vacina Aftosa',
      dataAplicacao: DateTime.now().subtract(const Duration(days: 20)),
      carenciaDias: 7,
    ),
    AplicacaoSanitaria(
      id: '3',
      gadoBrinco: 'BRC003',
      medicamentoNome: 'Antibiótico',
      dataAplicacao: DateTime.now().subtract(const Duration(days: 3)),
      carenciaDias: 21,
    ),
    AplicacaoSanitaria(
      id: '4',
      gadoBrinco: 'BRC004',
      medicamentoNome: 'Vermífugo',
      dataAplicacao: DateTime.now().subtract(const Duration(days: 10)),
      carenciaDias: 10,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final formatDate = DateFormat('dd/MM/yyyy');
    final aplicacoes = _aplicacoesMock;

    // Separar em carência e liberados
    final emCarencia = aplicacoes.where((a) => a.emCarencia).toList()
      ..sort((a, b) => a.diasRestantes.compareTo(b.diasRestantes));

    final liberados = aplicacoes.where((a) => !a.emCarencia).toList()
      ..sort((a, b) => b.dataAplicacao.compareTo(a.dataAplicacao));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório Sanitário'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _gerarPDF(aplicacoes, formatDate),
            tooltip: 'Gerar PDF',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (emCarencia.isNotEmpty) ...[
            const Text(
              'ANIMAIS EM CARÊNCIA',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            ...emCarencia.map((aplicacao) => Card(
              color: Colors.orange.shade50,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text(
                    '${aplicacao.diasRestantes}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text('Brinco: ${aplicacao.gadoBrinco}'),
                subtitle: Text(
                  '${aplicacao.medicamentoNome}\n'
                  'Aplicação: ${formatDate.format(aplicacao.dataAplicacao)}\n'
                  'Liberação: ${formatDate.format(aplicacao.dataLiberacao)}',
                ),
                trailing: Text(
                  '${aplicacao.diasRestantes} dias',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )),
            const SizedBox(height: 24),
          ],
          if (liberados.isNotEmpty) ...[
            const Text(
              'ANIMAIS LIBERADOS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            ...liberados.map((aplicacao) => Card(
              color: Colors.green.shade50,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white),
                ),
                title: Text('Brinco: ${aplicacao.gadoBrinco}'),
                subtitle: Text(
                  '${aplicacao.medicamentoNome}\n'
                  'Aplicação: ${formatDate.format(aplicacao.dataAplicacao)}\n'
                  'Liberado desde: ${formatDate.format(aplicacao.dataLiberacao)}',
                ),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              ),
            )),
          ],
        ],
      ),
    );
  }

  Future<void> _gerarPDF(
    List<AplicacaoSanitaria> aplicacoes,
    DateFormat formatDate,
  ) async {
    if (aplicacoes.isEmpty) {
      Get.snackbar(
        'Aviso',
        'Não há dados para gerar o relatório',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final dados = aplicacoes.map((aplicacao) => [
      aplicacao.gadoBrinco,
      aplicacao.medicamentoNome,
      formatDate.format(aplicacao.dataAplicacao),
      formatDate.format(aplicacao.dataLiberacao),
      aplicacao.emCarencia
        ? 'EM CARÊNCIA (${aplicacao.diasRestantes} dias)'
        : 'LIBERADO',
    ]).toList();

    final emCarencia = aplicacoes.where((a) => a.emCarencia).length;

    await PdfService.gerarRelatorio(
      titulo: 'Relatório Sanitário',
      subtitulo: 'Total de aplicações: ${aplicacoes.length} | Em carência: $emCarencia',
      colunas: ['Brinco', 'Medicamento', 'Aplicação', 'Liberação', 'Status'],
      dados: dados,
    );
  }
}
