import 'package:conquant_agro/presentation/screens/administrativo/forms/transacao_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/financeiro_controller.dart';
import '../../widgets/custom_drawer.dart';

class FluxoCaixaScreen extends StatelessWidget {
  const FluxoCaixaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FinanceiroController());
    final formatCurrency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final formatDate = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluxo de Caixa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: () {
              Get.snackbar(
                'Em desenvolvimento',
                'Importar CSV será implementado',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            tooltip: 'Importar CSV',
          ),
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
          // Card de Saldo
          Obx(() => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha((255 * 0.3).round()),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saldo Acumulado',
                      style: TextStyle( // Use a cor do tema para texto sobre a cor primária
                        color: Color.fromRGBO(255, 255, 255, 0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatCurrency.format(controller.saldoTotal),
                      style: TextStyle( // Use a cor do tema
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Receitas',
                              style: TextStyle( // Use a cor do tema
                                color: Color.fromRGBO(255, 255, 255, 0.7),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              formatCurrency.format(controller.totalReceitas),
                              style: TextStyle( // Use a cor do tema
                                color: Theme.of(context).colorScheme.onPrimary,
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
                              'Despesas',
                              style: TextStyle( // Use a cor do tema
                                color: Color.fromRGBO(255, 255, 255, 0.7),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              formatCurrency.format(controller.totalDespesas),
                              style: TextStyle( // Use a cor do tema
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
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
                  final valor = transacao.valor;
                  final isReceita = valor > 0;
                  final conciliado = transacao.conciliado;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isReceita
                            ? AppColors.receita.withAlpha((255 * 0.1).round())
                            : AppColors.despesa.withAlpha((255 * 0.1).round()),
                        child: Icon(
                          isReceita ? Icons.arrow_upward : Icons.arrow_downward,
                          color: isReceita ? AppColors.receita : AppColors.despesa,
                        ),
                      ),
                      title: Text(
                        transacao.descricao,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        formatDate.format(transacao.data),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatCurrency.format(valor.abs()),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isReceita ? AppColors.receita : AppColors.despesa,
                            ),
                          ),
                          if (conciliado)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withAlpha((255 * 0.1).round()),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Conciliado',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                        ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const TransacaoForm());
        },
        child: const Icon(Icons.add),
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
                    title: const Text('Apenas pendentes'),
                    value: controller.showApenasPendentes.value,
                    onChanged: (value) {
                      controller.showApenasPendentes.value = value;
                    },
                  )),
              Obx(() => ListTile(
                    title: const Text('Tipo'),
                    trailing: DropdownButton<String>(
                      value: controller.filtroTipo.value,
                      items: const [
                        DropdownMenuItem(value: 'TODOS', child: Text('Todos')),
                        DropdownMenuItem(value: 'receita', child: Text('Receitas')),
                        DropdownMenuItem(value: 'despesa', child: Text('Despesas')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          controller.filtroTipo.value = value;
                        }
                      },
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}