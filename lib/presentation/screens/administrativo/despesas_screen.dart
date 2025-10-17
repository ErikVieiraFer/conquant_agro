import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/financeiro_controller.dart';
import '../../widgets/custom_drawer.dart';

class DespesasScreen extends StatelessWidget {
  const DespesasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FinanceiroController());
    final formatCurrency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final formatDate = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _mostrarFiltros(context, controller),
            tooltip: 'Filtros',
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          // Card Resumo
          Obx(() => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.despesa.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.despesa.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total de Despesas',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatCurrency.format(controller.totalDespesas.abs()),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.despesa,
                      ),
                    ),
                  ],
                ),
              )),

          // Lista de Despesas
          Expanded(
            child: Obx(() {
              final despesas = controller.despesasFiltradas;

              if (despesas.isEmpty) {
                return const Center(
                  child: Text('Nenhuma despesa encontrada'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: despesas.length,
                itemBuilder: (context, index) {
                  final despesa = despesas[index];
                  final valor = despesa['valor'] as double;
                  final conciliado = despesa['conciliado'] as bool;
                  final finalidade = despesa['finalidade'] as String;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.despesa.withOpacity(0.1),
                        child: Icon(
                          _getIconeFinalidade(finalidade),
                          color: AppColors.despesa,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        despesa['descricao'],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            formatDate.format(DateTime.parse(despesa['data'])),
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  despesa['natureza'],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  finalidade,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatCurrency.format(valor.abs()),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.despesa,
                            ),
                          ),
                          if (conciliado)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Conciliado',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                        ],
                      ),
                      onTap: () {
                        Get.snackbar(
                          'Em desenvolvimento',
                          'Editar despesa',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.snackbar(
            'Em desenvolvimento',
            'Adicionar nova despesa',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Despesa'),
      ),
    );
  }

  IconData _getIconeFinalidade(String finalidade) {
    switch (finalidade) {
      case 'CUSTO':
        return Icons.attach_money;
      case 'ALMOXARIFADO':
        return Icons.inventory;
      case 'FLUXO_CAIXA':
        return Icons.account_balance_wallet;
      default:
        return Icons.receipt_long;
    }
  }

  void _mostrarFiltros(BuildContext context, FinanceiroController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filtros',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => SwitchListTile(
                    title: const Text('Apenas não conciliadas'),
                    value: controller.showApenasPendentes.value,
                    onChanged: (value) {
                      controller.showApenasPendentes.value = value;
                    },
                  )),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'Em desenvolvimento',
                    'Filtro por período será implementado',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text('Filtrar por Período'),
              ),
            ],
          ),
        );
      },
    );
  }
}