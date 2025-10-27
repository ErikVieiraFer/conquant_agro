import 'package:conquant_agro/data/mock/pasto_mock.dart';
import '../models/pasto.dart';

class PastoRepository {
  Future<List<Pasto>> getPastos() async {
    return PastoMockData.pastos;
  }

  Future<void> addPasto(Pasto pasto) async {
    final novoPasto = pasto.copyWith(id: DateTime.now().toString());
    PastoMockData.pastos.add(novoPasto);
  }

  Future<void> updatePasto(Pasto pasto) async {
    final index = PastoMockData.pastos.indexWhere((p) => p.id == pasto.id);
    if (index != -1) {
      PastoMockData.pastos[index] = pasto;
    }
  }
}
