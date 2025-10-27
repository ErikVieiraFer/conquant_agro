class Pasto {
  final String id;
  final String nome;
  final double area;
  final String idPropriedade;

  Pasto({
    required this.id,
    required this.nome,
    required this.area,
    required this.idPropriedade,
  });

  Pasto copyWith({
    String? id,
    String? nome,
    double? area,
    String? idPropriedade,
  }) {
    return Pasto(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      area: area ?? this.area,
      idPropriedade: idPropriedade ?? this.idPropriedade,
    );
  }
}