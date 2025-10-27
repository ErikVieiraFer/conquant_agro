class Cliente {
  final String id;
  final String nome;
  final String cnpj;
  final bool ativo;
  final DateTime dataVencimento;

  Cliente({
    required this.id,
    required this.nome,
    required this.cnpj,
    required this.ativo,
    required this.dataVencimento,
  });
}
