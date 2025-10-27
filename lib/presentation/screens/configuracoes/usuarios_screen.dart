import 'package:conquant_agro/presentation/controllers/usuario_controller.dart';
import 'package:conquant_agro/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsuariosScreen extends StatelessWidget {
  const UsuariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UsuarioController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
      ),
      body: Obx(() {
        if (controller.usuarios.isEmpty) {
          return const Center(
            child: Text('Nenhum usuário encontrado.'),
          );
        }

        return ListView.builder(
          itemCount: controller.usuarios.length,
          itemBuilder: (context, index) {
            final usuario = controller.usuarios[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(usuario.nome),
                subtitle: Text(usuario.email),
                trailing: Text(
                  usuario.ativo ? 'Ativo' : 'Inativo',
                  style: TextStyle(
                    color: usuario.ativo ? Colors.green : Colors.red,
                  ),
                ),
                onTap: () {
                  Get.toNamed(AppRoutes.usuarioForm, arguments: usuario);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.usuarioForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}