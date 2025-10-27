import 'package:conquant_agro/data/mock/movimentacao_mock.dart';
import '../models/movimentacao.dart';

class MovimentacaoRepository {
  Future<List<Movimentacao>> getMovimentacoes() async {
    return MovimentacaoMockData.movimentacoes;
  }

  Future<void> addMovimentacao(Movimentacao movimentacao) async {
    final novaMovimentacao = Movimentacao(
      id: DateTime.now().toString(),
      gadoId: movimentacao.gadoId,
      pastoOrigemId: movimentacao.pastoOrigemId,
      pastoDestinoId: movimentacao.pastoDestinoId,
      data: movimentacao.data,
    );
    MovimentacaoMockData.movimentacoes.add(novaMovimentacao);
  }

  Future<void> updateMovimentacao(Movimentacao movimentacao) async {
    final index = MovimentacaoMockData.movimentacoes.indexWhere((m) => m.id == movimentacao.id);
    if (index != -1) {
      MovimentacaoMockData.movimentacoes[index] = movimentacao;
    }
  }

  Future<void> deleteMovimentacao(String id) async {
    MovimentacaoMockData.movimentacoes.removeWhere((m) => m.id == id);
  }
}
