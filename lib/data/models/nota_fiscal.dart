enum TipoNotaFiscal { entrada, saida }

class NotaFiscal {
  final String? id;
  final TipoNotaFiscal tipo;
  final String numero;
  final String serie;
  final DateTime dataEmissao;
  final double valorTotal;
  final String cnpjEmitente;
  final String razaoSocialEmitente;
  final String? cnpjDestinatario;
  final String? chaveAcesso;
  final bool conciliado;

  NotaFiscal({
    this.id,
    required this.tipo,
    required this.numero,
    required this.serie,
    required this.dataEmissao,
    required this.valorTotal,
    required this.cnpjEmitente,
    required this.razaoSocialEmitente,
    this.cnpjDestinatario,
    this.chaveAcesso,
    this.conciliado = false,
  });
}