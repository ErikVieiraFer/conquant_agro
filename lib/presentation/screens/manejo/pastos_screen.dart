import 'package:conquant_agro/presentation/controllers/pasto_controller.dart';
import 'package:conquant_agro/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PastosScreen extends StatelessWidget {
  const PastosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PastoController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pastos'),
      ),
      body: Obx(() {
        if (controller.pastos.isEmpty) {
          return const Center(
            child: Text('Nenhum pasto encontrado.'),
          );
        }

        return ListView.builder(
          itemCount: controller.pastos.length,
          itemBuilder: (context, index) {
            final pasto = controller.pastos[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(pasto.nome),
                subtitle: Text('${pasto.area} ha'),
                onTap: () {
                  Get.toNamed(AppRoutes.pastoForm, arguments: pasto);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.pastoForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}