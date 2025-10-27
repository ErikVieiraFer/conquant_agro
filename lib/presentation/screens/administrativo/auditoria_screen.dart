import 'package:conquant_agro/presentation/controllers/auditoria_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AuditoriaScreen extends StatelessWidget {
  const AuditoriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuditoriaController());
    final formatDate = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs de Auditoria'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                // TODO: Implement search functionality
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.logs.isEmpty) {
                return const Center(
                  child: Text('Nenhum log de auditoria encontrado.'),
                );
              }

              return ListView.builder(
                itemCount: controller.logs.length,
                itemBuilder: (context, index) {
                  final log = controller.logs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${log.tabela} - ${log.acao}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Usuário ID: ${log.usuarioId}'),
                          Text('Registro ID: ${log.registroId}'),
                          Text('Data: ${formatDate.format(log.dataHora)}'),
                          const SizedBox(height: 8),
                          if (log.valorAnterior != null)
                            Text('Valor Anterior: ${log.valorAnterior}'),
                          if (log.valorNovo != null)
                            Text('Valor Novo: ${log.valorNovo}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
