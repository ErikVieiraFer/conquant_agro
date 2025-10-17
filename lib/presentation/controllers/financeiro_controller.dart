import 'package:get/get.dart';
import '../../data/mock/mock_data.dart';

class FinanceiroController extends GetxController {
  // Transações Bancárias
  final RxList<Map<String, dynamic>> transacoes = <Map<String, dynamic>>[].obs;
  
  // Despesas
  final RxList<Map<String, dynamic>> despesas = <Map<String, dynamic>>[].obs;
  
  // Notas Fiscais
  final RxList<Map<String, dynamic>> notasFiscais = <Map<String, dynamic>>[].obs;
  
  // Filtros
  final RxString filtroTipo = 'TODOS'.obs;
  final RxBool showApenasPendentes = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    carregarDados();
  }
  
  void carregarDados() {
    transacoes.value = List.from(MockData.transacoes);
    despesas.value = List.from(MockData.despesas);
    notasFiscais.value = List.from(MockData.notasFiscais);
  }
  
  // Filtros
  List<Map<String, dynamic>> get transacoesFiltradas {
    var lista = transacoes.toList();
    
    if (filtroTipo.value != 'TODOS') {
      lista = lista.where((t) => t['tipo'] == filtroTipo.value).toList();
    }
    
    if (showApenasPendentes.value) {
      lista = lista.where((t) => t['conciliado'] == false).toList();
    }
    
    return lista;
  }
  
  List<Map<String, dynamic>> get despesasFiltradas {
    var lista = despesas.toList();
    
    if (showApenasPendentes.value) {
      lista = lista.where((d) => d['conciliado'] == false).toList();
    }
    
    return lista;
  }
  
  List<Map<String, dynamic>> get notasFiscaisFiltradas {
    var lista = notasFiscais.toList();
    
    if (filtroTipo.value != 'TODOS') {
      lista = lista.where((nf) => nf['tipo'] == filtroTipo.value).toList();
    }
    
    return lista;
  }
  
  // Cálculos
  double get saldoTotal {
    return transacoes.fold(0.0, (sum, t) => sum + (t['valor'] as double));
  }
  
  double get totalDespesas {
    return despesas.fold(0.0, (sum, d) => sum + (d['valor'] as double));
  }
  
  double get totalReceitas {
    return transacoes
        .where((t) => t['tipo'] == 'RECEITA')
        .fold(0.0, (sum, t) => sum + (t['valor'] as double));
  }
}