import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/gado_controller.dart';
import '../../routes/app_routes.dart';

class GadosScreen extends StatelessWidget {
  const GadosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GadoController());
    final authController = Get.find<AuthController>();
    final formatDate = DateFormat('dd/MM/yyyy');

    // Carregar gados da propriedade atual
    if (authController.propriedadeAtual.value?.id != null) {
      controller.carregarGados(authController.propriedadeAtual.value!.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (authController.propriedadeAtual.value?.id != null) {
                controller.carregarGados(authController.propriedadeAtual.value!.id);
              }
            },
            tooltip: 'Atualizar',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implementar filtros
              Get.snackbar(
                'Em desenvolvimento',
                'Filtros em breve',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            tooltip: 'Filtrar',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.gados.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.gados.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pets,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhum gado cadastrado',
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
          padding: const EdgeInsets.all(16),
          itemCount: controller.gados.length,
          itemBuilder: (context, index) {
            final gado = controller.gados[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: gado.sexo == 'Macho'
                      ? Colors.blue.withAlpha((255 * 0.1).round())
                      : Colors.pink.withAlpha((255 * 0.1).round()),
                  child: Icon(
                    gado.sexo == 'Macho' ? Icons.male : Icons.female,
                    color: gado.sexo == 'Macho' ? Colors.blue : Colors.pink,
                  ),
                ),
                title: Text(
                  'ID: ${gado.idUsual}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      '${gado.raca} - ${gado.sexo}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    if (gado.idEletronico != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.sensors, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            gado.idEletronico!,
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      gado.idadeFormatada,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatDate.format(gado.dataNascimento),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Informações detalhadas
                        if (gado.pelagem != null)
                          _buildInfoRow('Pelagem', gado.pelagem!),
                        if (gado.grauSangue != null)
                          _buildInfoRow(
                            'Grau de Sangue',
                            '${gado.grauSangue!.toStringAsFixed(1)}%',
                          ),
                        if (gado.rgnRgd != null)
                          _buildInfoRow('RGN/RGD', gado.rgnRgd!),
                        if (gado.loteEntrada != null)
                          _buildInfoRow('Lote Entrada', gado.loteEntrada!),
                        if (gado.loteSaida != null)
                          _buildInfoRow('Lote Saída', gado.loteSaida!),

                        const Divider(height: 24),

                        // Botões de ação
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Get.toNamed(AppRoutes.gadoForm, arguments: gado);
                                },
                                icon: const Icon(Icons.edit, size: 18),
                                label: const Text('Editar'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // TODO: Implementar visualização de detalhes
                                  Get.snackbar(
                                    'Em desenvolvimento',
                                    'Detalhes completos em breve',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                },
                                icon: const Icon(Icons.info, size: 18),
                                label: const Text('Detalhes'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(AppRoutes.gadoForm);
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo Gado'),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
