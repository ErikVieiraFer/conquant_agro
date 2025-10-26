import 'package:conquant_agro/data/models/nota_fiscal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/financeiro_controller.dart';
import '../../widgets/custom_drawer.dart';

class ConciliacaoScreen extends StatelessWidget {
  const ConciliacaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FinanceiroController());
    final formatCurrency =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conciliação Bancária'),
      ),
      drawer: const CustomDrawer(),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Instrução
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.info, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Vincule transações bancárias com despesas. O saldo deve ser zero para conciliar.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
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
                  Tab(text: 'Conciliação Bancária'),
                  Tab(text: 'Status NF'),
                ],
              ),
            ),

            // Conteúdo
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Conciliação Bancária
                  _buildConciliacaoBancaria(controller, formatCurrency),

                  // Tab 2: Status NF
                  _buildStatusNF(controller, formatCurrency),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.snackbar(
            'Em desenvolvimento',
            'Fechar conciliação do mês',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        icon: const Icon(Icons.check_circle),
        label: const Text('Fechar Mês'),
      ),
    );
  }

  Widget _buildConciliacaoBancaria(
    FinanceiroController controller,
    NumberFormat formatCurrency,
  ) {
    return Obx(() {
      final transacoesPendentes =
          controller.transacoes.where((t) => !t.conciliado).toList();
      final despesasPendentes =
          controller.despesas.where((d) => !d.conciliado).toList();

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Painel: Transações em Aberto
            _buildPainel(
              titulo: 'Transações Bancárias (${transacoesPendentes.length})',
              cor: Colors.blue,
              children: transacoesPendentes.map((t) {
                final valor = t.valor;
                final isReceita = valor > 0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      isReceita ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isReceita ? AppColors.receita : AppColors.despesa,
                      size: 20,
                    ),
                    title: Text(
                      t.descricao,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy').format(t.data),
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: Text(
                      formatCurrency.format(valor.abs()),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color:
                            isReceita ? AppColors.receita : AppColors.despesa,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Saldo e Ação
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saldo da Seleção',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        'R\$ 0,00',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.snackbar(
                        'Em desenvolvimento',
                        'Vincular itens selecionados',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: const Icon(Icons.link, size: 18),
                    label: const Text('Vincular'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Painel: Despesas em Aberto
            _buildPainel(
              titulo: 'Despesas (${despesasPendentes.length})',
              cor: Colors.orange,
              children: despesasPendentes.map((d) {
                final valor = d.valor;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.receipt_long,
                      color: AppColors.despesa,
                      size: 20,
                    ),
                    title: Text(
                      d.descricao,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy').format(d.data),
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: Text(
                      formatCurrency.format(valor.abs()),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.despesa,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Painel: Vinculados
            _buildPainel(
              titulo: 'Vinculados (0)',
              cor: Colors.green,
              children: const [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Nenhum item vinculado ainda',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatusNF(
    FinanceiroController controller,
    NumberFormat formatCurrency,
  ) {
    return Obx(() {
      final nfsPendentes = controller.notasFiscais.toList();

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Legenda de Status
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status Fiscal:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildStatusChip('Pendente', Colors.orange),
                      _buildStatusChip('Com Nota', Colors.green),
                      _buildStatusChip('Divergente', Colors.red),
                      _buildStatusChip('Sem Nota', Colors.grey),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Lista de NFs
            ...nfsPendentes.map((nf) {
              final isEntrada = nf.tipo == TipoNotaFiscal.entrada;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(
                    isEntrada ? Icons.call_received : Icons.call_made,
                    color: isEntrada ? AppColors.receita : AppColors.despesa,
                  ),
                  title: Text(
                    'NF ${nf.numero} - ${nf.razaoSocialEmitente}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    formatCurrency.format(nf.valorTotal),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Pendente',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down, size: 16),
                        ],
                      ),
                    ),
                    onSelected: (status) {
                      Get.snackbar(
                        'Em desenvolvimento',
                        'Alterar status para: $status',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'pendente',
                        child: Text('Pendente'),
                      ),
                      const PopupMenuItem(
                        value: 'com_nota',
                        child: Text('Com Nota'),
                      ),
                      const PopupMenuItem(
                        value: 'divergente',
                        child: Text('Divergente'),
                      ),
                      const PopupMenuItem(
                        value: 'sem_nota',
                        child: Text('Sem Nota'),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildPainel({
    required String titulo,
    required Color cor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: cor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              titulo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: cor.withOpacity(0.8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color cor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: cor.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: cor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
