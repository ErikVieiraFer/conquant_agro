import 'package:conquant_agro/presentation/controllers/propriedade_controller.dart';
import 'package:conquant_agro/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropriedadesScreen extends StatelessWidget {
  const PropriedadesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PropriedadeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Propriedades'),
      ),
      body: Obx(() {
        if (controller.propriedades.isEmpty) {
          return const Center(
            child: Text('Nenhuma propriedade encontrada.'),
          );
        }

        return ListView.builder(
          itemCount: controller.propriedades.length,
          itemBuilder: (context, index) {
            final propriedade = controller.propriedades[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(propriedade.nome),
                subtitle: Text(propriedade.cnpj ?? ''),
                trailing: Text(
                  propriedade.bloqueado ? 'Bloqueada' : 'Ativa',
                  style: TextStyle(
                    color: propriedade.bloqueado ? Colors.red : Colors.green,
                  ),
                ),
                onTap: () {
                  Get.toNamed(AppRoutes.propriedadeForm, arguments: propriedade);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.propriedadeForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}