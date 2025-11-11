enum SistemaEstoque {
  peps, // Primeiro a Entrar, Primeiro a Sair
  ueps, // Último a Entrar, Primeiro a Sair
}

class Almoxarifado {
  final String? id;
  final String propriedadeId;
  final String nome;
  final String? descricao;
  final String unidade; // kg, L, unidade, saca, etc.
  final SistemaEstoque sistema;
  final double estoqueDisponivel;
  final double custoMedio;

  Almoxarifado({
    this.id,
    required this.propriedadeId,
    required this.nome,
    this.descricao,
    required this.unidade,
    this.sistema = SistemaEstoque.peps,
    this.estoqueDisponivel = 0.0,
    this.custoMedio = 0.0,
  });

  String get sistemaDescricao {
    switch (sistema) {
      case SistemaEstoque.peps:
        return 'PEPS';
      case SistemaEstoque.ueps:
        return 'UEPS';
    }
  }

  factory Almoxarifado.fromJson(Map<String, dynamic> json) {
    return Almoxarifado(
      id: json['id'],
      propriedadeId: json['propriedade_id'],
      nome: json['nome'],
      descricao: json['descricao'],
      unidade: json['unidade'],
      sistema: json['sistema'] == 'UEPS'
          ? SistemaEstoque.ueps
          : SistemaEstoque.peps,
      estoqueDisponivel: (json['estoque_disponivel'] ?? 0.0).toDouble(),
      custoMedio: (json['custo_medio'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'propriedade_id': propriedadeId,
      'nome': nome,
      'descricao': descricao,
      'unidade': unidade,
      'sistema': sistemaDescricao,
    };
  }

  Almoxarifado copyWith({
    String? id,
    String? propriedadeId,
    String? nome,
    String? descricao,
    String? unidade,
    SistemaEstoque? sistema,
    double? estoqueDisponivel,
    double? custoMedio,
  }) {
    return Almoxarifado(
      id: id ?? this.id,
      propriedadeId: propriedadeId ?? this.propriedadeId,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      unidade: unidade ?? this.unidade,
      sistema: sistema ?? this.sistema,
      estoqueDisponivel: estoqueDisponivel ?? this.estoqueDisponivel,
      custoMedio: custoMedio ?? this.custoMedio,
    );
  }
}
