class Vinculo {
  final String? id;
  final String propriedadeId;
  final String extratoId;
  final String despesaId;
  final String conciliacaoId;
  final DateTime? dataCriacao;
  final double? valor;

  Vinculo({
    this.id,
    required this.propriedadeId,
    required this.extratoId,
    required this.despesaId,
    required this.conciliacaoId,
    this.dataCriacao,
    this.valor,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propriedade_id': propriedadeId,
      'extrato_id': extratoId,
      'despesa_id': despesaId,
      'conciliacao_id': conciliacaoId,
      'data_criacao': dataCriacao?.toIso8601String(),
      'valor': valor,
    };
  }

  factory Vinculo.fromJson(Map<String, dynamic> json) {
    return Vinculo(
      id: json['id'],
      propriedadeId: json['propriedade_id'],
      extratoId: json['extrato_id'],
      despesaId: json['despesa_id'],
      conciliacaoId: json['conciliacao_id'],
      dataCriacao: json['data_criacao'] != null
          ? DateTime.parse(json['data_criacao'])
          : null,
      valor: json['valor']?.toDouble(),
    );
  }

  Vinculo copyWith({
    String? id,
    String? propriedadeId,
    String? extratoId,
    String? despesaId,
    String? conciliacaoId,
    DateTime? dataCriacao,
    double? valor,
  }) {
    return Vinculo(
      id: id ?? this.id,
      propriedadeId: propriedadeId ?? this.propriedadeId,
      extratoId: extratoId ?? this.extratoId,
      despesaId: despesaId ?? this.despesaId,
      conciliacaoId: conciliacaoId ?? this.conciliacaoId,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      valor: valor ?? this.valor,
    );
  }
}
