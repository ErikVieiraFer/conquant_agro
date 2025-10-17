class Propriedade {
  final String id;
  final String nome;
  final String? cnpj;
  final String? endereco;
  final bool bloqueado;

  Propriedade({
    required this.id,
    required this.nome,
    this.cnpj,
    this.endereco,
    this.bloqueado = false,
  });

  factory Propriedade.fromJson(Map<String, dynamic> json) {
    return Propriedade(
      id: json['id'],
      nome: json['nome'],
      cnpj: json['cnpj'],
      endereco: json['endereco'],
      bloqueado: json['bloqueado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cnpj': cnpj,
      'endereco': endereco,
      'bloqueado': bloqueado,
    };
  }
}