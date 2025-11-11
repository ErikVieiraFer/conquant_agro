enum StatusConciliacao {
  pendente,
  emAndamento,
  concluida,
  cancelada,
}

class Conciliacao {
  final String? id;
  final String propriedadeId;
  final int mes;
  final int ano;
  final DateTime? dataCriacao;
  final DateTime? dataFinalizacao;
  final StatusConciliacao status;
  final String? observacao;
  final double? saldoInicial;
  final double? saldoFinal;
  final double? saldoCalculado;

  Conciliacao({
    this.id,
    required this.propriedadeId,
    required this.mes,
    required this.ano,
    this.dataCriacao,
    this.dataFinalizacao,
    this.status = StatusConciliacao.pendente,
    this.observacao,
    this.saldoInicial,
    this.saldoFinal,
    this.saldoCalculado,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propriedade_id': propriedadeId,
      'mes': mes,
      'ano': ano,
      'data_criacao': dataCriacao?.toIso8601String(),
      'data_finalizacao': dataFinalizacao?.toIso8601String(),
      'status': status.index,
      'observacao': observacao,
      'saldo_inicial': saldoInicial,
      'saldo_final': saldoFinal,
      'saldo_calculado': saldoCalculado,
    };
  }

  factory Conciliacao.fromJson(Map<String, dynamic> json) {
    return Conciliacao(
      id: json['id'],
      propriedadeId: json['propriedade_id'],
      mes: json['mes'],
      ano: json['ano'],
      dataCriacao: json['data_criacao'] != null
          ? DateTime.parse(json['data_criacao'])
          : null,
      dataFinalizacao: json['data_finalizacao'] != null
          ? DateTime.parse(json['data_finalizacao'])
          : null,
      status: StatusConciliacao.values[json['status'] ?? 0],
      observacao: json['observacao'],
      saldoInicial: json['saldo_inicial']?.toDouble(),
      saldoFinal: json['saldo_final']?.toDouble(),
      saldoCalculado: json['saldo_calculado']?.toDouble(),
    );
  }

  Conciliacao copyWith({
    String? id,
    String? propriedadeId,
    int? mes,
    int? ano,
    DateTime? dataCriacao,
    DateTime? dataFinalizacao,
    StatusConciliacao? status,
    String? observacao,
    double? saldoInicial,
    double? saldoFinal,
    double? saldoCalculado,
  }) {
    return Conciliacao(
      id: id ?? this.id,
      propriedadeId: propriedadeId ?? this.propriedadeId,
      mes: mes ?? this.mes,
      ano: ano ?? this.ano,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataFinalizacao: dataFinalizacao ?? this.dataFinalizacao,
      status: status ?? this.status,
      observacao: observacao ?? this.observacao,
      saldoInicial: saldoInicial ?? this.saldoInicial,
      saldoFinal: saldoFinal ?? this.saldoFinal,
      saldoCalculado: saldoCalculado ?? this.saldoCalculado,
    );
  }

  bool get isConcluida => status == StatusConciliacao.concluida;
  bool get isPendente => status == StatusConciliacao.pendente;
  bool get isSaldoZerado => (saldoCalculado ?? 0.0).abs() < 0.01;

  String get periodoFormatado => '${mes.toString().padLeft(2, '0')}/$ano';
}
