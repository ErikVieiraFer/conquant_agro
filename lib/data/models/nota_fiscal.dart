enum TipoNotaFiscal { entrada, saida }

// Status da Nota Fiscal para Conciliação Fiscal
// 0: Aguardando Autorização
// 1: Autorizada
// 2: Cancelada
// 3: Denegada
// 4: Contingência
// 5: Inutilizada
// 6: Em Processamento
// 7: Conciliada
enum StatusNotaFiscal {
  aguardandoAutorizacao, // 0
  autorizada, // 1
  cancelada, // 2
  denegada, // 3
  contingencia, // 4
  inutilizada, // 5
  emProcessamento, // 6
  conciliada, // 7
}

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
  final StatusNotaFiscal status;

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
    this.status = StatusNotaFiscal.aguardandoAutorizacao,
  });

  String get statusDescricao {
    switch (status) {
      case StatusNotaFiscal.aguardandoAutorizacao:
        return 'Aguardando Autorização';
      case StatusNotaFiscal.autorizada:
        return 'Autorizada';
      case StatusNotaFiscal.cancelada:
        return 'Cancelada';
      case StatusNotaFiscal.denegada:
        return 'Denegada';
      case StatusNotaFiscal.contingencia:
        return 'Contingência';
      case StatusNotaFiscal.inutilizada:
        return 'Inutilizada';
      case StatusNotaFiscal.emProcessamento:
        return 'Em Processamento';
      case StatusNotaFiscal.conciliada:
        return 'Conciliada';
    }
  }

  NotaFiscal copyWith({
    String? id,
    TipoNotaFiscal? tipo,
    String? numero,
    String? serie,
    DateTime? dataEmissao,
    double? valorTotal,
    String? cnpjEmitente,
    String? razaoSocialEmitente,
    String? cnpjDestinatario,
    String? chaveAcesso,
    bool? conciliado,
    StatusNotaFiscal? status,
  }) {
    return NotaFiscal(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      numero: numero ?? this.numero,
      serie: serie ?? this.serie,
      dataEmissao: dataEmissao ?? this.dataEmissao,
      valorTotal: valorTotal ?? this.valorTotal,
      cnpjEmitente: cnpjEmitente ?? this.cnpjEmitente,
      razaoSocialEmitente: razaoSocialEmitente ?? this.razaoSocialEmitente,
      cnpjDestinatario: cnpjDestinatario ?? this.cnpjDestinatario,
      chaveAcesso: chaveAcesso ?? this.chaveAcesso,
      conciliado: conciliado ?? this.conciliado,
      status: status ?? this.status,
    );
  }
}