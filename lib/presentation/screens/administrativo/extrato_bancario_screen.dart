import 'package:conquant_agro/data/models/transacao.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/financeiro_controller.dart';
import '../../widgets/custom_drawer.dart';
import 'forms/transacao_form.dart';

class ExtratoBancarioScreen extends StatelessWidget {
  const ExtratoBancarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FinanceiroController());
    final formatCurrency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final formatDate = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Extrato Bancário'),
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
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Saldo Atual',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatCurrency.format(controller.saldoTotal),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              )),

          // Lista de Transações
          Expanded(
            child: Obx(() {
              final transacoes = controller.transacoesFiltradas;

              if (transacoes.isEmpty) {
                return const Center(
                  child: Text('Nenhuma transação encontrada'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: transacoes.length,
                itemBuilder: (context, index) {
                  final transacao = transacoes[index];
                  final isReceita = transacao.tipo == TipoTransacao.receita;
                  final valor = transacao.valor;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isReceita
                            ? AppColors.receita.withOpacity(0.1)
                            : AppColors.despesa.withOpacity(0.1),
                        child: Icon(
                          isReceita ? Icons.arrow_upward : Icons.arrow_downward,
                          color: isReceita ? AppColors.receita : AppColors.despesa,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        transacao.descricao,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        formatDate.format(transacao.data),
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Text(
                        formatCurrency.format(valor),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isReceita ? AppColors.receita : AppColors.despesa,
                        ),
                      ),
                      onTap: () {
                        Get.to(() => TransacaoForm(transacao: transacao));
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
          Get.to(() => const TransacaoForm());
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Transação'),
      ),
    );
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
