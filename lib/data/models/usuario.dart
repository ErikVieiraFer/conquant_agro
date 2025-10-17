import '../../core/constants/permissoes.dart';

class Usuario {
  final String id;
  final String nome;
  final String email;
  final Permissao permissao;
  final String propriedadeId;
  final bool ativo;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.permissao,
    required this.propriedadeId,
    this.ativo = true,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      permissao: Permissao.values.byName(json['permissao']),
      propriedadeId: json['propriedade_id'],
      ativo: json['ativo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'permissao': permissao.name,
      'propriedade_id': propriedadeId,
      'ativo': ativo,
    };
  }
}