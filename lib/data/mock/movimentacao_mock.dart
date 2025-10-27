import '../models/movimentacao.dart';

class MovimentacaoMockData {
  static final List<Movimentacao> movimentacoes = [
    Movimentacao(
      id: '1',
      gadoId: '1',
      pastoOrigemId: '1',
      pastoDestinoId: '2',
      data: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Movimentacao(
      id: '2',
      gadoId: '2',
      pastoOrigemId: '1',
      pastoDestinoId: '2',
      data: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Movimentacao(
      id: '3',
      gadoId: '3',
      pastoOrigemId: '2',
      pastoDestinoId: '1',
      data: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];
}
