import 'package:conquant_agro/presentation/screens/dashboards/dashboard_financeiro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Drawer(
      child: Column(
        children: [
          Obx(() {
            final usuario = authController.usuarioAtual.value;
            return UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              accountName: Text(
                authController.propriedadeAtual.value?.nome ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                usuario?.nome ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white, // Cor de fundo do CircleAvatar
                child: ClipOval(
                  child: Image.asset(
                    'assets/icons/ConOuant icon.png',
                    fit: BoxFit.cover, // Ajuste o fit conforme necessário
                    width: 90, // Defina um tamanho para o CircleAvatar
                    height: 90,
                  ),
                ),
              ),
              otherAccountsPictures: [
                CircleAvatar(
                  backgroundColor: Colors.white70,
                  child: IconButton(
                    icon: const Icon(
                      Icons.swap_horiz,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      Get.snackbar(
                        'Em desenvolvimento',
                        'Trocar propriedade será implementado',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                ),
              ],
            );
          }),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  icon: Icons.home,
                  title: 'Início',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.home);
                  },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'ADMINISTRATIVO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                _buildMenuItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  onTap: () {
                    Get.back();
                    Get.to(() => const DashboardFinanceiroScreen());
                  },
                ),
                _buildMenuItem(
                  icon: Icons.account_balance,
                  title: 'Extrato Bancário',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.extratoBancario);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.account_balance_wallet,
                  title: 'Fluxo de Caixa',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.fluxoCaixa);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.receipt_long,
                  title: 'Despesas',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.despesas);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.description,
                  title: 'Notas Fiscais',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.notasFiscais);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.check_circle,
                  title: 'Conciliação',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.conciliacao);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.inventory,
                  title: 'Almoxarifado',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.almoxarifado);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.assessment,
                  title: 'Relatórios',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.relatorios);
                  },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'MANEJO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                _buildMenuItem(
                  icon: Icons.pets,
                  title: 'Gados',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.gados);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.grass,
                  title: 'Pastos',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.pastos);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.compare_arrows,
                  title: 'Movimentações',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.movimentacoes);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.favorite,
                  title: 'Cruzamentos',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.cruzamentos);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.history,
                  title: 'Categorias de Histórico',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.categoriasHistorico);
                  },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'PESAGEM',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                _buildMenuItem(
                  icon: Icons.scale,
                  title: 'Grupos de Pesagem',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.pesagensGrupos);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.scale,
                  title: 'Pesagens',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.pesagem);
                  },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'CONFIGURAÇÕES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                _buildMenuItem(
                  icon: Icons.people,
                  title: 'Usuários',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.usuarios);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.business,
                  title: 'Propriedades',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.propriedades);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.groups,
                  title: 'Clientes',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.clientes);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.policy,
                  title: 'Auditoria',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.auditoria);
                  },
                ),
              ],
            ),
          ),

          // Footer - Logout
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Sair', style: TextStyle(color: Colors.red)),
            onTap: () {
              Get.back();
              authController.logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
