import 'package:conquant_agro/presentation/controllers/movimentacao_gado_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MovimentacoesGadoScreen extends StatelessWidget {
  const MovimentacoesGadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String gadoId = Get.arguments as String;
    final controller = Get.put(MovimentacaoGadoController(gadoId));
    final formatDate = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text('Movimentações do Gado $gadoId'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.movimentacoesGado.isEmpty) {
          return const Center(
            child: Text('Nenhuma movimentação encontrada para este gado.'),
          );
        }

        return ListView.builder(
          itemCount: controller.movimentacoesGado.length,
          itemBuilder: (context, index) {
            final movimentacao = controller.movimentacoesGado[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                    'De Pasto ${movimentacao.pastoOrigemId} para Pasto ${movimentacao.pastoDestinoId}'),
                trailing: Text(formatDate.format(movimentacao.data)),
              ),
            );
          },
        );
      }),
    );
  }
}
