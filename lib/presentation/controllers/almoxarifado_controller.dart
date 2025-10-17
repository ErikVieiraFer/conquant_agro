import 'package:get/get.dart';
import '../../data/mock/mock_data.dart';

class AlmoxarifadoController extends GetxController {
  final RxList<Map<String, dynamic>> materiais = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> racoes = <Map<String, dynamic>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    carregarDados();
  }
  
  void carregarDados() {
    materiais.value = List.from(MockData.materiaisAlmoxarifado);
    racoes.value = List.from(MockData.racoes);
  }
  
  // Cálculo de valor total do estoque
  double get valorTotalEstoque {
    return materiais.fold(0.0, (sum, m) {
      final estoque = m['estoque_disponivel'] as double;
      final custo = m['custo_medio'] as double;
      return sum + (estoque * custo);
    });
  }
}