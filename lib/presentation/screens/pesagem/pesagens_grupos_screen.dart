import 'package:conquant_agro/presentation/controllers/pesagem_grupo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PesagensGruposScreen extends StatelessWidget {
  const PesagensGruposScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PesagemGrupoController());
    final formatDate = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grupos de Pesagem'),
      ),
      body: Obx(() {
        if (controller.pesagensGrupos.isEmpty) {
          return const Center(
            child: Text('Nenhum grupo de pesagem encontrado.'),
          );
        }

        return ListView.builder(
          itemCount: controller.pesagensGrupos.length,
          itemBuilder: (context, index) {
            final grupo = controller.pesagensGrupos[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(grupo.nome),
                subtitle: Text(formatDate.format(grupo.data)),
                onTap: () {
                  // TODO: Implement edit group
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add group
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
