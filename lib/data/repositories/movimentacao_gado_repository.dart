import 'package:conquant_agro/data/mock/movimentacao_gado_mock.dart';
import '../models/movimentacao_gado.dart';

class MovimentacaoGadoRepository {
  Future<List<MovimentacaoGado>> getMovimentacoesGado(String gadoId) async {
    return MovimentacaoGadoMockData.movimentacoesGado
        .where((m) => m.gadoId == gadoId)
        .toList();
  }

  Future<void> addMovimentacaoGado(MovimentacaoGado movimentacao) async {
    final novaMovimentacao = MovimentacaoGado(
      id: DateTime.now().toString(),
      gadoId: movimentacao.gadoId,
      pastoOrigemId: movimentacao.pastoOrigemId,
      pastoDestinoId: movimentacao.pastoDestinoId,
      data: movimentacao.data,
    );
    MovimentacaoGadoMockData.movimentacoesGado.add(novaMovimentacao);
  }
}
