class Movimentacao {
  final String id;
  final String gadoId;
  final String pastoOrigemId;
  final String pastoDestinoId;
  final DateTime data;

  Movimentacao({
    required this.id,
    required this.gadoId,
    required this.pastoOrigemId,
    required this.pastoDestinoId,
    required this.data,
  });
}