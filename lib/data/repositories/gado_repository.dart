import 'package:conquant_agro/data/mock/gado_mock.dart';
import '../models/gado.dart';

class GadoRepository {
  Future<List<Gado>> getGados() async {
    // Lógica para buscar gados na API
    return GadoMockData.gados;
  }

  Future<void> addGado(Gado gado) async {
    final novoGado = gado.copyWith(id: DateTime.now().toString());
    GadoMockData.gados.add(novoGado);
  }

  Future<void> updateGado(Gado gado) async {
    final index = GadoMockData.gados.indexWhere((g) => g.id == gado.id);
    if (index != -1) {
      GadoMockData.gados[index] = gado;
    }
  }
}