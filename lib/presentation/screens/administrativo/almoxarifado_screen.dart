import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/almoxarifado_controller.dart';
import '../../widgets/custom_drawer.dart';

class AlmoxarifadoScreen extends StatelessWidget {
  const AlmoxarifadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AlmoxarifadoController());
    final formatCurrency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final formatNumber = NumberFormat.decimalPattern('pt_BR');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Almoxarifado'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Get.snackbar(
                'Em desenvolvimento',
                'Busca de materiais',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            tooltip: 'Buscar',
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          // Card Valor Total Estoque
          Obx(() => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.inventory, color: Colors.white70, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Valor Total do Estoque',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatCurrency.format(controller.valorTotalEstoque),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),

          // Tabs: Materiais e Rações
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
                        Tab(text: 'Materiais'),
                        Tab(text: 'Rações'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Tab Materiais
                        Obx(() {
                          final materiais = controller.materiais;

                          if (materiais.isEmpty) {
                            return const Center(
                              child: Text('Nenhum material cadastrado'),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: materiais.length,
                            itemBuilder: (context, index) {
                              final material = materiais[index];
                              final estoque = material['estoque_disponivel'] as double;
                              final custo = material['custo_medio'] as double;
                              final valorTotal = estoque * custo;

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ExpansionTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.primary.withOpacity(0.1),
                                    child: const Icon(
                                      Icons.inventory_2,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    material['nome'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        material['descricao'] ?? '',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: material['sistema'] == 'PEPS'
                                              ? Colors.blue.withOpacity(0.1)
                                              : Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          material['sistema'],
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: material['sistema'] == 'PEPS'
                                                ? Colors.blue
                                                : Colors.orange,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${formatNumber.format(estoque)} ${material['unidade']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        formatCurrency.format(valorTotal),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Custo Médio:'),
                                              Text(
                                                '${formatCurrency.format(custo)} / ${material['unidade']}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(height: 24),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    Get.snackbar(
                                                      'Em desenvolvimento',
                                                      'Registrar entrada de ${material['nome']}',
                                                      snackPosition: SnackPosition.BOTTOM,
                                                    );
                                                  },
                                                  icon: const Icon(Icons.add, size: 18),
                                                  label: const Text('Entrada'),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppColors.success,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    Get.snackbar(
                                                      'Em desenvolvimento',
                                                      'Registrar saída de ${material['nome']}',
                                                      snackPosition: SnackPosition.BOTTOM,
                                                    );
                                                  },
                                                  icon: const Icon(Icons.remove, size: 18),
                                                  label: const Text('Saída'),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppColors.warning,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),

                        // Tab Rações
                        Obx(() {
                          final racoes = controller.racoes;

                          if (racoes.isEmpty) {
                            return const Center(
                              child: Text('Nenhuma ração cadastrada'),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: racoes.length,
                            itemBuilder: (context, index) {
                              final racao = racoes[index];
                              final composicao =
                                  racao['composicao'] as List<dynamic>;

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ExpansionTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.orange.withOpacity(0.1),
                                    child: const Icon(
                                      Icons.grass,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    racao['nome'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Text(
                                    racao['descricao'] ?? '',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  trailing: Text(
                                    '${formatCurrency.format(racao['custo_kg'])} /kg',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Composição:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ...composicao.map((ing) {
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 4),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(ing['ingrediente']),
                                                  Text(
                                                    '${ing['quantidade']}${ing['unidade']}',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.snackbar(
            'Em desenvolvimento',
            'Adicionar novo material/ração',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
      ),
    );
  }
}