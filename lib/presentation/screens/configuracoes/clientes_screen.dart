import 'package:conquant_agro/presentation/controllers/cliente_controller.dart';
import 'package:conquant_agro/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ClienteController());
    final formatDate = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: Obx(() {
        if (controller.clientes.isEmpty) {
          return const Center(
            child: Text('Nenhum cliente encontrado.'),
          );
        }

        return ListView.builder(
          itemCount: controller.clientes.length,
          itemBuilder: (context, index) {
            final cliente = controller.clientes[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(cliente.nome),
                subtitle: Text(cliente.cnpj),
                trailing: Text(
                  cliente.ativo ? 'Ativo' : 'Inativo',
                  style: TextStyle(
                    color: cliente.ativo ? Colors.green : Colors.red,
                  ),
                ),
                onTap: () {
                  Get.toNamed(AppRoutes.clienteForm, arguments: cliente);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.clienteForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
