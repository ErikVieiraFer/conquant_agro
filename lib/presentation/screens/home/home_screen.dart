import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConQuant Agro'),
      ),
      drawer: const CustomDrawer(),
      body: Obx(() {
        final usuario = authController.usuarioAtual.value;
        final propriedade = authController.propriedadeAtual.value;
        
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 100,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),
                Text(
                  'Bem-vindo, ${usuario?.nome ?? ""}!',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  propriedade?.nome ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Permissão: ${usuario?.permissao.nome}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Use o menu lateral para navegar',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}