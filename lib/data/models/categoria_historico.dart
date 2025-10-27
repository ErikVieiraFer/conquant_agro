class CategoriaHistorico {
  final String id;
  final String nome;

  CategoriaHistorico({
    required this.id,
    required this.nome,
  });

  CategoriaHistorico copyWith({
    String? id,
    String? nome,
  }) {
    return CategoriaHistorico(
      id: id ?? this.id,
      nome: nome ?? this.nome,
    );
  }
}
