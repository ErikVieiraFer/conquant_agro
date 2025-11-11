class Gado {
  final String? id;
  final String propriedadeId;
  final String? idEletronico; // RFID
  final String idUsual; // Brinco visual (obrigatório)
  final String raca;
  final double? grauSangue; // 0 a 100%
  final String sexo; // Macho, Fêmea
  final String? pelagem;
  final DateTime dataNascimento;
  final String? rgnRgd; // Registro genealógico
  final String? loteEntrada;
  final String? loteSaida;
  final String? pastoId;

  Gado({
    this.id,
    required this.propriedadeId,
    this.idEletronico,
    required this.idUsual,
    required this.raca,
    this.grauSangue,
    required this.sexo,
    this.pelagem,
    required this.dataNascimento,
    this.rgnRgd,
    this.loteEntrada,
    this.loteSaida,
    this.pastoId,
  });

  // Getters úteis
  int get idadeEmMeses {
    final agora = DateTime.now();
    int anos = agora.year - dataNascimento.year;
    int meses = agora.month - dataNascimento.month;

    if (meses < 0) {
      anos--;
      meses += 12;
    }

    return (anos * 12) + meses;
  }

  String get idadeFormatada {
    final meses = idadeEmMeses;
    if (meses < 12) {
      return '$meses ${meses == 1 ? 'mês' : 'meses'}';
    }
    final anos = meses ~/ 12;
    final mesesRestantes = meses % 12;
    if (mesesRestantes == 0) {
      return '$anos ${anos == 1 ? 'ano' : 'anos'}';
    }
    return '$anos ${anos == 1 ? 'ano' : 'anos'} e $mesesRestantes ${mesesRestantes == 1 ? 'mês' : 'meses'}';
  }

  factory Gado.fromJson(Map<String, dynamic> json) {
    return Gado(
      id: json['id'],
      propriedadeId: json['propriedade_id'],
      idEletronico: json['id_eletronico'],
      idUsual: json['id_usual'],
      raca: json['raca'],
      grauSangue: json['grau_sangue']?.toDouble(),
      sexo: json['sexo'],
      pelagem: json['pelagem'],
      dataNascimento: DateTime.parse(json['data_nascimento']),
      rgnRgd: json['rgn_rgd'],
      loteEntrada: json['lote_entrada'],
      loteSaida: json['lote_saida'],
      pastoId: json['pasto_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'propriedade_id': propriedadeId,
      if (idEletronico != null) 'id_eletronico': idEletronico,
      'id_usual': idUsual,
      'raca': raca,
      if (grauSangue != null) 'grau_sangue': grauSangue,
      'sexo': sexo,
      if (pelagem != null) 'pelagem': pelagem,
      'data_nascimento': dataNascimento.toIso8601String().split('T')[0],
      if (rgnRgd != null) 'rgn_rgd': rgnRgd,
      if (loteEntrada != null) 'lote_entrada': loteEntrada,
      if (loteSaida != null) 'lote_saida': loteSaida,
      if (pastoId != null) 'pasto_id': pastoId,
    };
  }

  Gado copyWith({
    String? id,
    String? propriedadeId,
    String? idEletronico,
    String? idUsual,
    String? raca,
    double? grauSangue,
    String? sexo,
    String? pelagem,
    DateTime? dataNascimento,
    String? rgnRgd,
    String? loteEntrada,
    String? loteSaida,
    String? pastoId,
  }) {
    return Gado(
      id: id ?? this.id,
      propriedadeId: propriedadeId ?? this.propriedadeId,
      idEletronico: idEletronico ?? this.idEletronico,
      idUsual: idUsual ?? this.idUsual,
      raca: raca ?? this.raca,
      grauSangue: grauSangue ?? this.grauSangue,
      sexo: sexo ?? this.sexo,
      pelagem: pelagem ?? this.pelagem,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      rgnRgd: rgnRgd ?? this.rgnRgd,
      loteEntrada: loteEntrada ?? this.loteEntrada,
      loteSaida: loteSaida ?? this.loteSaida,
      pastoId: pastoId ?? this.pastoId,
    );
  }
}

// Listas padrão de raças e pelagens (podem vir do back-end)
class RacaBovina {
  final String nome;

  RacaBovina({required this.nome});

  factory RacaBovina.fromJson(Map<String, dynamic> json) {
    return RacaBovina(nome: json['nome']);
  }
}

class Pelagem {
  final String nome;

  Pelagem({required this.nome});

  factory Pelagem.fromJson(Map<String, dynamic> json) {
    return Pelagem(nome: json['nome']);
  }
}
