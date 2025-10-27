import 'package:conquant_agro/presentation/controllers/gado_controller.dart';
import 'package:conquant_agro/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GadosScreen extends StatelessWidget {
  const GadosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GadoController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gados'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.gados.isEmpty) {
          return const Center(
            child: Text('Nenhum gado encontrado.'),
          );
        }

        return ListView.builder(
          itemCount: controller.gados.length,
          itemBuilder: (context, index) {
            final gado = controller.gados[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text('Brinco: ${gado.brinco}'),
                subtitle: Text(gado.raca),
                onTap: () {
                  Get.toNamed(AppRoutes.gadoForm, arguments: gado);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.gadoForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}