import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/almoxarifado.dart';
import '../../controllers/almoxarifado_controller.dart';

class AlmoxarifadoHistoricoScreen extends StatefulWidget {
  const AlmoxarifadoHistoricoScreen({super.key});

  @override
  State<AlmoxarifadoHistoricoScreen> createState() =>
      _AlmoxarifadoHistoricoScreenState();
}

class _AlmoxarifadoHistoricoScreenState
    extends State<AlmoxarifadoHistoricoScreen> {
  final controller = Get.find<AlmoxarifadoController>();
  final formatDate = DateFormat('dd/MM/yyyy');
  final formatCurrency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final formatNumber = NumberFormat.decimalPattern('pt_BR');

  Almoxarifado? material;

  @override
  void initState() {
    super.initState();

    // Recebe material como argumento
    if (Get.arguments != null && Get.arguments is Almoxarifado) {
      material = Get.arguments as Almoxarifado;
      _carregarHistorico();
    }
  }

  Future<void> _carregarHistorico() async {
    if (material?.id == null) return;

    await Future.wait([
      controller.carregarEntradas(
        controller.propriedadeIdAtual.value,
        almoxarifadoId: material!.id,
      ),
      controller.carregarSaidas(
        controller.propriedadeIdAtual.value,
        almoxarifadoId: material!.id,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (material == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Histórico')),
        body: const Center(
          child: Text('Material não encontrado'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Movimentações'),
      ),
      body: Column(
        children: [
          // Card com informações do material
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: material!.sistema == SistemaEstoque.peps
                    ? [Colors.blue, Colors.blue.shade700]
                    : [Colors.orange, Colors.orange.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: (material!.sistema == SistemaEstoque.peps
                          ? Colors.blue
                          : Colors.orange)
                      .withAlpha((255 * 0.3).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material!.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((255 * 0.2).round()),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Sistema: ${material!.sistemaDescricao}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white54, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estoque Atual',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          '${formatNumber.format(material!.estoqueDisponivel)} ${material!.unidade}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Custo Médio',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          '${formatCurrency.format(material!.custoMedio)}/${material!.unidade}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tabs de Entradas e Saídas
          DefaultTabController(
            length: 2,
            child: Expanded(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((255 * 0.05).round()),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const TabBar(
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.textSecondary,
                      indicatorColor: AppColors.primary,
                      tabs: [
                        Tab(text: 'Entradas'),
                        Tab(text: 'Saídas'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return TabBarView(
                        children: [
                          // Tab Entradas
                          _buildEntradasList(),
                          // Tab Saídas
                          _buildSaidasList(),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntradasList() {
    final entradas = controller.entradas;

    if (entradas.isEmpty) {
      return const Center(
        child: Text('Nenhuma entrada registrada'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: entradas.length,
      itemBuilder: (context, index) {
        final entrada = entradas[index];
        final disponivel = entrada.quantidadeDisponivel;
        final consumido = entrada.quantidade - disponivel;
        final percentualDisponivel = (disponivel / entrada.quantidade) * 100;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green.withAlpha((255 * 0.1).round()),
              child: const Icon(Icons.add, color: Colors.green),
            ),
            title: Text(
              formatDate.format(entrada.dataEntrada),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '${formatNumber.format(entrada.quantidade)} ${material!.unidade} × ${formatCurrency.format(entrada.valorUnitario)}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: percentualDisponivel / 100,
                  backgroundColor: Colors.red.withAlpha((255 * 0.2).round()),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                const SizedBox(height: 2),
                Text(
                  'Disponível: ${formatNumber.format(disponivel)} ${material!.unidade} (${percentualDisponivel.toStringAsFixed(0)}%)',
                  style: const TextStyle(fontSize: 11, color: Colors.green),
                ),
              ],
            ),
            trailing: Text(
              formatCurrency.format(entrada.valorTotal),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.green,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (entrada.fornecedor != null)
                      _buildDetalheRow('Fornecedor', entrada.fornecedor!),
                    if (entrada.notaFiscal != null)
                      _buildDetalheRow('Nota Fiscal', entrada.notaFiscal!),
                    if (entrada.observacao != null)
                      _buildDetalheRow('Observação', entrada.observacao!),
                    if (consumido > 0) ...[
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Consumido:',
                              style: TextStyle(color: Colors.red)),
                          Text(
                            '${formatNumber.format(consumido)} ${material!.unidade}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSaidasList() {
    final saidas = controller.saidas;

    if (saidas.isEmpty) {
      return const Center(
        child: Text('Nenhuma saída registrada'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: saidas.length,
      itemBuilder: (context, index) {
        final saida = saidas[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange.withAlpha((255 * 0.1).round()),
              child: const Icon(Icons.remove, color: Colors.orange),
            ),
            title: Text(
              formatDate.format(saida.dataSaida),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '${formatNumber.format(saida.quantidade)} ${material!.unidade}',
                  style: const TextStyle(fontSize: 14),
                ),
                if (saida.destino != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Destino: ${saida.destino}',
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ],
            ),
            trailing: saida.valorTotal != null
                ? Text(
                    formatCurrency.format(saida.valorTotal),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.orange,
                    ),
                  )
                : null,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (saida.valorUnitarioMedio != null)
                      _buildDetalheRow(
                        'Valor Unitário Médio',
                        '${formatCurrency.format(saida.valorUnitarioMedio)}/${material!.unidade}',
                      ),
                    if (saida.observacao != null)
                      _buildDetalheRow('Observação', saida.observacao!),
                    if (saida.lotes != null && saida.lotes!.isNotEmpty) ...[
                      const Divider(),
                      const Text(
                        'Lotes Consumidos:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...saida.lotes!.map((lote) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${formatDate.format(lote.dataEntrada)} - ${formatNumber.format(lote.quantidadeConsumida)} ${material!.unidade}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                formatCurrency.format(lote.valorTotal),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetalheRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
