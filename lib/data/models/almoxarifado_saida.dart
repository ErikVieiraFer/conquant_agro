class AlmoxarifadoSaida {
  final String? id;
  final String propriedadeId;
  final String almoxarifadoId;
  final double quantidade;
  final DateTime dataSaida;
  final String? observacao;
  final String? destino;
  final double? valorUnitarioMedio; // Calculado pelo back-end baseado em PEPS/UEPS
  final List<SaidaLote>? lotes; // Detalhamento dos lotes consumidos (opcional, retornado pelo back-end)

  AlmoxarifadoSaida({
    this.id,
    required this.propriedadeId,
    required this.almoxarifadoId,
    required this.quantidade,
    required this.dataSaida,
    this.observacao,
    this.destino,
    this.valorUnitarioMedio,
    this.lotes,
  });

  double? get valorTotal => valorUnitarioMedio != null
      ? quantidade * valorUnitarioMedio!
      : null;

  factory AlmoxarifadoSaida.fromJson(Map<String, dynamic> json) {
    return AlmoxarifadoSaida(
      id: json['id'],
      propriedadeId: json['propriedade_id'],
      almoxarifadoId: json['almoxarifado_id'],
      quantidade: (json['quantidade']).toDouble(),
      dataSaida: DateTime.parse(json['data_saida']),
      observacao: json['observacao'],
      destino: json['destino'],
      valorUnitarioMedio: json['valor_unitario_medio']?.toDouble(),
      lotes: json['lotes'] != null
          ? (json['lotes'] as List).map((l) => SaidaLote.fromJson(l)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'propriedade_id': propriedadeId,
      'almoxarifado_id': almoxarifadoId,
      'quantidade': quantidade,
      'data_saida': dataSaida.toIso8601String().split('T')[0],
      if (observacao != null) 'observacao': observacao,
      if (destino != null) 'destino': destino,
    };
  }

  AlmoxarifadoSaida copyWith({
    String? id,
    String? propriedadeId,
    String? almoxarifadoId,
    double? quantidade,
    DateTime? dataSaida,
    String? observacao,
    String? destino,
    double? valorUnitarioMedio,
    List<SaidaLote>? lotes,
  }) {
    return AlmoxarifadoSaida(
      id: id ?? this.id,
      propriedadeId: propriedadeId ?? this.propriedadeId,
      almoxarifadoId: almoxarifadoId ?? this.almoxarifadoId,
      quantidade: quantidade ?? this.quantidade,
      dataSaida: dataSaida ?? this.dataSaida,
      observacao: observacao ?? this.observacao,
      destino: destino ?? this.destino,
      valorUnitarioMedio: valorUnitarioMedio ?? this.valorUnitarioMedio,
      lotes: lotes ?? this.lotes,
    );
  }
}

// Classe auxiliar para detalhar os lotes consumidos em uma saída
class SaidaLote {
  final String entradaId;
  final double quantidadeConsumida;
  final double valorUnitario;
  final DateTime dataEntrada;

  SaidaLote({
    required this.entradaId,
    required this.quantidadeConsumida,
    required this.valorUnitario,
    required this.dataEntrada,
  });

  factory SaidaLote.fromJson(Map<String, dynamic> json) {
    return SaidaLote(
      entradaId: json['entrada_id'],
      quantidadeConsumida: (json['quantidade_consumida']).toDouble(),
      valorUnitario: (json['valor_unitario']).toDouble(),
      dataEntrada: DateTime.parse(json['data_entrada']),
    );
  }

  double get valorTotal => quantidadeConsumida * valorUnitario;
}
