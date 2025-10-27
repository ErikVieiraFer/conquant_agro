import 'package:conquant_agro/presentation/controllers/movimentacao_controller.dart';
import 'package:conquant_agro/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MovimentacoesScreen extends StatelessWidget {
  const MovimentacoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MovimentacaoController());
    final formatDate = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimentações'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.movimentacoes.isEmpty) {
          return const Center(
            child: Text('Nenhuma movimentação encontrada.'),
          );
        }

        return ListView.builder(
          itemCount: controller.movimentacoes.length,
          itemBuilder: (context, index) {
            final movimentacao = controller.movimentacoes[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text('Gado ID: ${movimentacao.gadoId}'),
                subtitle: Text(
                    'De Pasto ${movimentacao.pastoOrigemId} para Pasto ${movimentacao.pastoDestinoId}'),
                trailing: Text(formatDate.format(movimentacao.data)),
                onTap: () {
                  Get.toNamed(AppRoutes.movimentacaoForm, arguments: movimentacao);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.movimentacaoForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}