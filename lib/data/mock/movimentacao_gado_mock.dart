import '../models/movimentacao_gado.dart';

class MovimentacaoGadoMockData {
  static final List<MovimentacaoGado> movimentacoesGado = [
    MovimentacaoGado(
      id: '1',
      gadoId: '1',
      pastoOrigemId: '1',
      pastoDestinoId: '2',
      data: DateTime.now().subtract(const Duration(days: 10)),
    ),
    MovimentacaoGado(
      id: '2',
      gadoId: '1',
      pastoOrigemId: '2',
      pastoDestinoId: '3',
      data: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
}
