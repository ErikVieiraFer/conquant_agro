import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/almoxarifado.dart';
import '../../controllers/almoxarifado_controller.dart';
import '../../widgets/custom_drawer.dart';
import 'almoxarifado_form_screen.dart';
import 'almoxarifado_entrada_form_screen.dart';
import 'almoxarifado_saida_form_screen.dart';
import 'almoxarifado_historico_screen.dart';

class AlmoxarifadoScreen extends StatelessWidget {
  const AlmoxarifadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AlmoxarifadoController());
    final formatCurrency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final formatNumber = NumberFormat.decimalPattern('pt_BR');

    // Carregar materiais ao iniciar (usar propriedade_id do contexto)
    // TODO: Substituir por propriedade_id real do usuário logado
    if (controller.propriedadeIdAtual.value.isEmpty) {
      controller.propriedadeIdAtual.value = 'PROP_ID_EXEMPLO';
      controller.carregarMateriais(controller.propriedadeIdAtual.value);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Almoxarifado'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.carregarMateriais(controller.propriedadeIdAtual.value);
            },
            tooltip: 'Atualizar',
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
                      color: Colors.blue.withAlpha((255 * 0.3).round()),
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

          // Lista de Materiais
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.materiais.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.materiais.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum material cadastrado',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toque no botão + para adicionar',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                itemCount: controller.materiais.length,
                itemBuilder: (context, index) {
                  final material = controller.materiais[index];
                  final estoque = material.estoqueDisponivel;
                  final custo = material.custoMedio;
                  final valorTotal = estoque * custo;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: material.sistema == SistemaEstoque.peps
                            ? Colors.blue.withAlpha((255 * 0.1).round())
                            : Colors.orange.withAlpha((255 * 0.1).round()),
                        child: Icon(
                          Icons.inventory_2,
                          color: material.sistema == SistemaEstoque.peps
                              ? Colors.blue
                              : Colors.orange,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        material.nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (material.descricao != null &&
                              material.descricao!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              material.descricao!,
                              style: const TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: material.sistema == SistemaEstoque.peps
                                  ? Colors.blue.withAlpha((255 * 0.1).round())
                                  : Colors.orange.withAlpha((255 * 0.1).round()),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              material.sistemaDescricao,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: material.sistema == SistemaEstoque.peps
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
                            '${formatNumber.format(estoque)} ${material.unidade}',
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
                                    '${formatCurrency.format(custo)} / ${material.unidade}',
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
                                        Get.to(
                                          () =>
                                              const AlmoxarifadoEntradaFormScreen(),
                                          arguments: material,
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
                                        Get.to(
                                          () =>
                                              const AlmoxarifadoSaidaFormScreen(),
                                          arguments: material,
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
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        Get.to(
                                          () =>
                                              const AlmoxarifadoHistoricoScreen(),
                                          arguments: material,
                                        );
                                      },
                                      icon: const Icon(Icons.history, size: 18),
                                      label: const Text('Histórico'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        Get.to(
                                          () => const AlmoxarifadoFormScreen(),
                                          arguments: material,
                                        );
                                      },
                                      icon: const Icon(Icons.edit, size: 18),
                                      label: const Text('Editar'),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const AlmoxarifadoFormScreen());
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo Material'),
      ),
    );
  }
}
