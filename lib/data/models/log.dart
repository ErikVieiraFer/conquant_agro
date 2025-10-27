class Log {
  final String id;
  final DateTime dataHora;
  final String usuarioId;
  final String tabela;
  final String registroId;
  final String acao;
  final Map<String, dynamic>? valorAnterior;
  final Map<String, dynamic>? valorNovo;

  Log({
    required this.id,
    required this.dataHora,
    required this.usuarioId,
    required this.tabela,
    required this.registroId,
    required this.acao,
    this.valorAnterior,
    this.valorNovo,
  });
}
