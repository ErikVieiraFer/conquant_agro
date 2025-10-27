import 'package:conquant_agro/data/mock/categoria_historico_mock.dart';
import '../models/categoria_historico.dart';

class CategoriaHistoricoRepository {
  Future<List<CategoriaHistorico>> getCategoriasHistorico() async {
    return CategoriaHistoricoMockData.categoriasHistorico;
  }

  Future<void> addCategoriaHistorico(CategoriaHistorico categoria) async {
    final novaCategoria = categoria.copyWith(id: DateTime.now().toString());
    CategoriaHistoricoMockData.categoriasHistorico.add(novaCategoria);
  }

  Future<void> updateCategoriaHistorico(CategoriaHistorico categoria) async {
    final index = CategoriaHistoricoMockData.categoriasHistorico.indexWhere((c) => c.id == categoria.id);
    if (index != -1) {
      CategoriaHistoricoMockData.categoriasHistorico[index] = categoria;
    }
  }

  Future<void> deleteCategoriaHistorico(String id) async {
    CategoriaHistoricoMockData.categoriasHistorico.removeWhere((c) => c.id == id);
  }
}
