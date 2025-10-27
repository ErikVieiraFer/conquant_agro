import 'package:conquant_agro/presentation/controllers/categoria_historico_controller.dart';
import 'package:conquant_agro/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriasHistoricoScreen extends StatelessWidget {
  const CategoriasHistoricoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoriaHistoricoController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias de Histórico'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.categoriasHistorico.isEmpty) {
          return const Center(
            child: Text('Nenhuma categoria encontrada.'),
          );
        }

        return ListView.builder(
          itemCount: controller.categoriasHistorico.length,
          itemBuilder: (context, index) {
            final categoria = controller.categoriasHistorico[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(categoria.nome),
                onTap: () {
                  Get.toNamed(AppRoutes.categoriaHistoricoForm, arguments: categoria);
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    controller.deleteCategoriaHistorico(categoria.id);
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.categoriaHistoricoForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
