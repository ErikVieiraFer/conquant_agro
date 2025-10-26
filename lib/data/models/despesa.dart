enum FinalidadeDespesa { custo, almoxarifado, fluxoCaixa }

class Despesa {
  final String? id;
  final DateTime data;
  final String descricao;
  final double valor;
  final String natureza;
  final FinalidadeDespesa finalidade;
  final String? observacao;
  final bool conciliado;

  Despesa({
    this.id,
    required this.data,
    required this.descricao,
    required this.valor,
    required this.natureza,
    required this.finalidade,
    this.observacao,
    this.conciliado = false,
  });
}