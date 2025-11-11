class AlmoxarifadoEntrada {
  final String? id;
  final String propriedadeId;
  final String almoxarifadoId;
  final double quantidade;
  final double quantidadeDisponivel; // Quantidade ainda disponível no lote (para PEPS/UEPS)
  final double valorUnitario;
  final DateTime dataEntrada;
  final String? observacao;
  final String? fornecedor;
  final String? notaFiscal;

  AlmoxarifadoEntrada({
    this.id,
    required this.propriedadeId,
    required this.almoxarifadoId,
    required this.quantidade,
    double? quantidadeDisponivel,
    required this.valorUnitario,
    required this.dataEntrada,
    this.observacao,
    this.fornecedor,
    this.notaFiscal,
  }) : quantidadeDisponivel = quantidadeDisponivel ?? quantidade;

  double get valorTotal => quantidade * valorUnitario;

  factory AlmoxarifadoEntrada.fromJson(Map<String, dynamic> json) {
    return AlmoxarifadoEntrada(
      id: json['id'],
      propriedadeId: json['propriedade_id'],
      almoxarifadoId: json['almoxarifado_id'],
      quantidade: (json['quantidade']).toDouble(),
      quantidadeDisponivel: (json['quantidade_disponivel'] ?? json['quantidade']).toDouble(),
      valorUnitario: (json['valor_unitario']).toDouble(),
      dataEntrada: DateTime.parse(json['data_entrada']),
      observacao: json['observacao'],
      fornecedor: json['fornecedor'],
      notaFiscal: json['nota_fiscal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'propriedade_id': propriedadeId,
      'almoxarifado_id': almoxarifadoId,
      'quantidade': quantidade,
      'valor_unitario': valorUnitario,
      'data_entrada': dataEntrada.toIso8601String().split('T')[0],
      if (observacao != null) 'observacao': observacao,
      if (fornecedor != null) 'fornecedor': fornecedor,
      if (notaFiscal != null) 'nota_fiscal': notaFiscal,
    };
  }

  AlmoxarifadoEntrada copyWith({
    String? id,
    String? propriedadeId,
    String? almoxarifadoId,
    double? quantidade,
    double? quantidadeDisponivel,
    double? valorUnitario,
    DateTime? dataEntrada,
    String? observacao,
    String? fornecedor,
    String? notaFiscal,
  }) {
    return AlmoxarifadoEntrada(
      id: id ?? this.id,
      propriedadeId: propriedadeId ?? this.propriedadeId,
      almoxarifadoId: almoxarifadoId ?? this.almoxarifadoId,
      quantidade: quantidade ?? this.quantidade,
      quantidadeDisponivel: quantidadeDisponivel ?? this.quantidadeDisponivel,
      valorUnitario: valorUnitario ?? this.valorUnitario,
      dataEntrada: dataEntrada ?? this.dataEntrada,
      observacao: observacao ?? this.observacao,
      fornecedor: fornecedor ?? this.fornecedor,
      notaFiscal: notaFiscal ?? this.notaFiscal,
    );
  }
}
