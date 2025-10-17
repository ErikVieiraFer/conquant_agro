import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/administrativo/fluxo_caixa_screen.dart';
import 'presentation/screens/administrativo/despesas_screen.dart';
import 'presentation/screens/administrativo/notas_fiscais_screen.dart';
import 'presentation/screens/administrativo/conciliacao_screen.dart';
import 'presentation/screens/administrativo/almoxarifado_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar controllers
  Get.put(AuthController(), permanent: true);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ConQuant Agro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: AppRoutes.login,
      getPages: [
        GetPage(
          name: AppRoutes.login,
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: AppRoutes.home,
          page: () => const HomeScreen(),
        ),
        GetPage(
          name: AppRoutes.fluxoCaixa,
          page: () => const FluxoCaixaScreen(),
        ),
        GetPage(
          name: AppRoutes.despesas,
          page: () => const DespesasScreen(),
        ),
        GetPage(
          name: AppRoutes.notasFiscais,
          page: () => const NotasFiscaisScreen(),
        ),
        GetPage(
          name: AppRoutes.conciliacao,
          page: () => const ConciliacaoScreen(),
        ),
        GetPage(
          name: AppRoutes.almoxarifado,
          page: () => const AlmoxarifadoScreen(),
        ),
        GetPage(
          name: AppRoutes.usuarios,
          page: () => const Scaffold(
            body: Center(child: Text('Usuários - Em desenvolvimento')),
          ),
        ),
        GetPage(
          name: AppRoutes.propriedades,
          page: () => const Scaffold(
            body: Center(child: Text('Propriedades - Em desenvolvimento')),
          ),
        ),
      ],
    );
  }
}