enum TipoTransacao { receita, despesa }

class Transacao {
  final String? id;
  final DateTime data;
  final String descricao;
  final double valor;
  final TipoTransacao tipo;
  final String contaBancaria;
  final bool conciliado;

  Transacao({
    this.id,
    required this.data,
    required this.descricao,
    required this.valor,
    required this.tipo,
    required this.contaBancaria,
    this.conciliado = false,
  });
}