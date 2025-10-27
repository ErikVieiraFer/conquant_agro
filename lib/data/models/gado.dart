class Gado {
  final String id;
  final String brinco;
  final String raca;
  final DateTime dataNascimento;
  final String pastoId;
  final String idPropriedade;

  Gado({
    required this.id,
    required this.brinco,
    required this.raca,
    required this.dataNascimento,
    required this.pastoId,
    required this.idPropriedade,
  });

  Gado copyWith({
    String? id,
    String? brinco,
    String? raca,
    DateTime? dataNascimento,
    String? pastoId,
    String? idPropriedade,
  }) {
    return Gado(
      id: id ?? this.id,
      brinco: brinco ?? this.brinco,
      raca: raca ?? this.raca,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      pastoId: pastoId ?? this.pastoId,
      idPropriedade: idPropriedade ?? this.idPropriedade,
    );
  }
}