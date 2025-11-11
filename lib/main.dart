import 'package:conquant_agro/presentation/controllers/almoxarifado_controller.dart';
import 'package:conquant_agro/presentation/controllers/auditoria_controller.dart';
import 'package:conquant_agro/presentation/controllers/categoria_historico_controller.dart';
import 'package:conquant_agro/presentation/controllers/cliente_controller.dart';
import 'package:conquant_agro/presentation/controllers/conciliacao_controller.dart';
import 'package:conquant_agro/presentation/controllers/financeiro_controller.dart';
import 'package:conquant_agro/presentation/controllers/gado_controller.dart';
import 'package:conquant_agro/presentation/controllers/manejo_controller.dart';
import 'package:conquant_agro/presentation/controllers/movimentacao_controller.dart';
import 'package:conquant_agro/presentation/controllers/pasto_controller.dart';
import 'package:conquant_agro/presentation/controllers/pesagem_controller.dart';
import 'package:conquant_agro/presentation/controllers/pesagem_grupo_controller.dart';
import 'package:conquant_agro/presentation/controllers/propriedade_controller.dart';
import 'package:conquant_agro/presentation/controllers/usuario_controller.dart';
import 'package:conquant_agro/presentation/controllers/zoosanitario_controller.dart';
import 'package:conquant_agro/presentation/screens/manejo/forms/movimentacao_gado_form.dart';
import 'package:conquant_agro/presentation/screens/manejo/movimentacoes_gado_screen.dart';
import 'package:conquant_agro/presentation/screens/administrativo/auditoria_screen.dart';
import 'package:conquant_agro/presentation/screens/administrativo/extrato_bancario_screen.dart';
import 'package:conquant_agro/presentation/screens/administrativo/forms/despesa_form.dart';
import 'package:conquant_agro/presentation/screens/administrativo/forms/nota_fiscal_form.dart';
import 'package:conquant_agro/presentation/screens/administrativo/forms/transacao_form.dart';
import 'package:conquant_agro/presentation/screens/configuracoes/clientes_screen.dart';
import 'package:conquant_agro/presentation/screens/configuracoes/forms/cliente_form.dart';
import 'package:conquant_agro/presentation/screens/configuracoes/forms/propriedade_form.dart';
import 'package:conquant_agro/presentation/screens/configuracoes/forms/usuario_form.dart';
import 'package:conquant_agro/presentation/screens/configuracoes/propriedades_screen.dart';
import 'package:conquant_agro/presentation/screens/configuracoes/usuarios_screen.dart';
import 'package:conquant_agro/presentation/screens/manejo/categorias_historico_screen.dart';
import 'package:conquant_agro/presentation/screens/manejo/cruzamentos_screen.dart';
import 'package:conquant_agro/presentation/screens/manejo/forms/categoria_historico_form.dart';
import 'package:conquant_agro/presentation/screens/manejo/forms/gado_form.dart';
import 'package:conquant_agro/presentation/screens/manejo/forms/movimentacao_form.dart';
import 'package:conquant_agro/presentation/screens/manejo/forms/pasto_form.dart';
import 'package:conquant_agro/presentation/screens/manejo/gados_screen.dart';
import 'package:conquant_agro/presentation/screens/manejo/movimentacoes_screen.dart';
import 'package:conquant_agro/presentation/screens/manejo/pastos_screen.dart';
import 'package:conquant_agro/presentation/screens/pesagem/dashboards/dashboard_producao.dart';
import 'package:conquant_agro/presentation/screens/pesagem/forms/pesagem_grupo_form.dart';
import 'package:conquant_agro/presentation/screens/pesagem/forms/pesagem_form.dart';
import 'package:conquant_agro/presentation/screens/pesagem/historico_pesagens_screen.dart';
import 'package:conquant_agro/presentation/screens/pesagem/pesagem_screen.dart';
import 'package:conquant_agro/presentation/screens/pesagem/pesagens_grupos_screen.dart';
import 'package:conquant_agro/presentation/screens/zoosanitario/aplicacoes_screen.dart';
import 'package:conquant_agro/presentation/screens/zoosanitario/forms/aplicacao_form.dart';
import 'package:conquant_agro/presentation/screens/zoosanitario/medicamentos_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
import 'presentation/screens/administrativo/relatorios_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar controllers
  Get.put(AuthController());
  Get.lazyPut(() => AlmoxarifadoController());
  Get.lazyPut(() => AuditoriaController());
  Get.lazyPut(() => CategoriaHistoricoController());
  Get.lazyPut(() => ClienteController());
  Get.lazyPut(() => ConciliacaoController());
  Get.lazyPut(() => FinanceiroController());
  Get.lazyPut(() => GadoController(), fenix: true);
  Get.lazyPut(() => ManejoController());
  Get.lazyPut(() => MovimentacaoController(), fenix: true);
  Get.lazyPut(() => PastoController(), fenix: true);
  Get.lazyPut(() => PesagemController());
  Get.lazyPut(() => PesagemGrupoController());
  Get.lazyPut(() => PropriedadeController());
  Get.lazyPut(() => UsuarioController());
  Get.lazyPut(() => ZoosanitarioController());

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
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      getPages: [
        GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
        GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
        GetPage(
            name: AppRoutes.fluxoCaixa, page: () => const FluxoCaixaScreen()),
        GetPage(name: AppRoutes.despesas, page: () => const DespesasScreen()),
        GetPage(
            name: AppRoutes.notasFiscais,
            page: () => const NotasFiscaisScreen()),
        GetPage(
            name: AppRoutes.conciliacao, page: () => const ConciliacaoScreen()),
        GetPage(
            name: AppRoutes.extratoBancario,
            page: () => const ExtratoBancarioScreen()),
        GetPage(
            name: AppRoutes.almoxarifado,
            page: () => const AlmoxarifadoScreen()),
        GetPage(name: AppRoutes.auditoria, page: () => const AuditoriaScreen()),
        GetPage(
            name: AppRoutes.relatorios, page: () => const RelatoriosScreen()),
        GetPage(name: AppRoutes.despesaForm, page: () => const DespesaForm()),
        GetPage(
            name: AppRoutes.transacaoForm, page: () => const TransacaoForm()),
        GetPage(
            name: AppRoutes.notaFiscalForm, page: () => const NotaFiscalForm()),
        GetPage(name: AppRoutes.usuarios, page: () => const UsuariosScreen()),
        GetPage(
            name: AppRoutes.propriedades,
            page: () => const PropriedadesScreen()),
        GetPage(name: AppRoutes.clientes, page: () => const ClientesScreen()),
        GetPage(name: AppRoutes.usuarioForm, page: () => const UsuarioForm()),
        GetPage(
            name: AppRoutes.propriedadeForm,
            page: () => const PropriedadeForm()),
        GetPage(name: AppRoutes.clienteForm, page: () => const ClienteForm()),
        GetPage(name: AppRoutes.gados, page: () => const GadosScreen()),
        GetPage(name: AppRoutes.pastos, page: () => const PastosScreen()),
        GetPage(
            name: AppRoutes.movimentacoes,
            page: () => const MovimentacoesScreen()),
        GetPage(
            name: AppRoutes.cruzamentos, page: () => const CruzamentosScreen()),
        GetPage(
            name: AppRoutes.categoriasHistorico,
            page: () => const CategoriasHistoricoScreen()),
        GetPage(name: AppRoutes.gadoForm, page: () => const GadoForm()),
        GetPage(name: AppRoutes.pastoForm, page: () => const PastoForm()),
        GetPage(
            name: AppRoutes.movimentacaoForm,
            page: () => const MovimentacaoForm()),
        GetPage(
            name: AppRoutes.categoriaHistoricoForm,
            page: () => const CategoriaHistoricoForm()),
        GetPage(
            name: AppRoutes.movimentacoesGado,
            page: () => const MovimentacoesGadoScreen()),
        GetPage(
            name: AppRoutes.movimentacaoGadoForm,
            page: () => const MovimentacaoGadoForm()),
        GetPage(name: AppRoutes.pesagem, page: () => const PesagemScreen()),
        GetPage(
            name: AppRoutes.pesagensGrupos,
            page: () => const PesagensGruposScreen()),
        GetPage(
            name: AppRoutes.historicoPesagens,
            page: () => const HistoricoPesagensScreen()),
        GetPage(
            name: AppRoutes.dashboardProducao,
            page: () => const DashboardProducao()),
        GetPage(
            name: AppRoutes.pesagemGrupoForm,
            page: () => const PesagemGrupoForm()),
        GetPage(name: AppRoutes.pesagemForm, page: () => const PesagemForm()),
        GetPage(
            name: AppRoutes.aplicacoes, page: () => const AplicacoesScreen()),
        GetPage(
            name: AppRoutes.medicamentos,
            page: () => const MedicamentosScreen()),
        GetPage(
            name: AppRoutes.aplicacaoForm, page: () => const AplicacaoForm()),
      ],
    );
  }
}
