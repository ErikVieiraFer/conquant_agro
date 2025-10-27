import 'package:conquant_agro/presentation/controllers/pesagem_controller.dart';
import 'package:conquant_agro/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PesagemScreen extends StatelessWidget {
  const PesagemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PesagemController());
    final formatDate = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesagens'),
      ),
      body: Obx(() {

        if (controller.pesagens.isEmpty) {
          return const Center(
            child: Text('Nenhuma pesagem encontrada.'),
          );
        }

        return ListView.builder(
          itemCount: controller.pesagens.length,
          itemBuilder: (context, index) {
            final pesagem = controller.pesagens[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text('Gado ID: ${pesagem.gadoId}'),
                subtitle: Text(formatDate.format(pesagem.data)),
                trailing: Text('${pesagem.peso} kg'),
                onTap: () {
                  Get.toNamed(AppRoutes.pesagemForm, arguments: pesagem);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.pesagemForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}