import 'package:conquant_agro/data/models/nota_fiscal.dart';
import 'package:conquant_agro/data/models/transacao.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart'; // Importar DateFormat
import '../screens/administrativo/widgets/fluxo_caixa_chart.dart'; // Importar FluxoCaixaData
import '../../data/mock/mock_data.dart';
import '../../data/models/despesa.dart';
import '../../data/models/natureza.dart';

class FinanceiroController extends GetxController {
  // Transações Bancárias
  final RxList<Transacao> transacoes = <Transacao>[].obs;
  
  // Despesas
  final RxList<Despesa> despesas = <Despesa>[].obs;
  final RxList<Natureza> naturezas = <Natureza>[].obs;
  
  // Notas Fiscais
  final RxList<NotaFiscal> notasFiscais = <NotaFiscal>[].obs;
  
  // Filtros
  final RxString filtroTipo = 'TODOS'.obs;
  final RxBool showApenasPendentes = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    carregarDados();
  }
  
  void carregarDados() {
    transacoes.value = MockData.transacoes.map((t) => Transacao(
      id: t['id'] as String,
      data: DateTime.parse(t['data'] as String),
      descricao: t['descricao'] as String,
      valor: (t['valor'] as num).toDouble(),
      tipo: _parseTipoTransacao(t['tipo'] as String),
      contaBancaria: 'Conta Principal', // Mock
      conciliado: t['conciliado'] as bool,
    )).toList();
    despesas.value = MockData.despesas.map((d) => Despesa(
      id: d['id'] as String,
      data: DateTime.parse(d['data'] as String),
      descricao: d['descricao'] as String,
      valor: (d['valor'] as num).toDouble(),
      natureza: d['natureza'] as String,
      finalidade: _parseFinalidadeDespesa(d['finalidade'] as String),
      conciliado: d['conciliado'] as bool,
    )).toList();
    naturezas.value = MockData.naturezas.map((n) => Natureza(
      id: n['id'] as String,
      nome: n['nome'] as String,
      categoria: n['categoria'] as String,
    )).toList();
    notasFiscais.value = MockData.notasFiscais.map((nf) => NotaFiscal(
      id: nf['id'] as String,
      tipo: _parseTipoNotaFiscal(nf['tipo'] as String),
      numero: nf['numero'] as String,
      serie: nf['serie'] as String,
      dataEmissao: DateTime.parse(nf['data_emissao'] as String),
      valorTotal: (nf['valor_total'] as num).toDouble(),
      razaoSocialEmitente: nf['razao_social_emitente'] as String,
      cnpjEmitente: nf['cnpj_emitente'] as String,
      cnpjDestinatario: nf['cnpj_destinatario'] as String?,
      chaveAcesso: nf['chave_acesso'] as String?,
      conciliado: nf['conciliado'] as bool,
    )).toList();
  }

  TipoTransacao _parseTipoTransacao(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'receita':
        return TipoTransacao.receita;
      case 'despesa':
        return TipoTransacao.despesa;
      default:
        throw Exception('Tipo de transação inválido: $tipo');
    }
  }

  FinalidadeDespesa _parseFinalidadeDespesa(String finalidade) {
    switch (finalidade.toLowerCase()) {
      case 'custo':
        return FinalidadeDespesa.custo;
      case 'almoxarifado':
        return FinalidadeDespesa.almoxarifado;
      case 'fluxo_caixa':
        return FinalidadeDespesa.fluxoCaixa;
      default:
        throw Exception('Finalidade de despesa inválida: $finalidade');
    }
  }

  TipoNotaFiscal _parseTipoNotaFiscal(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'entrada':
        return TipoNotaFiscal.entrada;
      case 'saida':
        return TipoNotaFiscal.saida;
      default:
        throw Exception('Tipo de nota fiscal inválido: $tipo');
    }
  }

  void adicionarDespesa(Despesa despesa) {
    final novaDespesa = Despesa(
      id: const Uuid().v4(),
      data: despesa.data,
      descricao: despesa.descricao,
      valor: despesa.valor,
      natureza: despesa.natureza,
      finalidade: despesa.finalidade,
      observacao: despesa.observacao,
      conciliado: false,
    );
    despesas.add(novaDespesa);
  }

  void atualizarDespesa(String id, Despesa despesa) {
    final index = despesas.indexWhere((d) => d.id == id);
    if (index != -1) {
      despesas[index] = despesa;
    }
  }

  void removerDespesa(String id) {
    despesas.removeWhere((d) => d.id == id);
  }

  void adicionarTransacao(Transacao transacao) {
    final novaTransacao = Transacao(
      id: const Uuid().v4(),
      data: transacao.data,
      descricao: transacao.descricao,
      valor: transacao.valor,
      tipo: transacao.tipo,
      contaBancaria: transacao.contaBancaria,
      conciliado: false,
    );
    transacoes.add(novaTransacao);
  }

  void atualizarTransacao(String id, Transacao transacao) {
    final index = transacoes.indexWhere((t) => t.id == id);
    if (index != -1) {
      transacoes[index] = transacao;
    }
  }

  void removerTransacao(String id) {
    transacoes.removeWhere((t) => t.id == id);
  }

  void adicionarNotaFiscal(NotaFiscal notaFiscal) {
    final novaNotaFiscal = NotaFiscal(
      id: const Uuid().v4(),
      tipo: notaFiscal.tipo,
      numero: notaFiscal.numero,
      serie: notaFiscal.serie,
      dataEmissao: notaFiscal.dataEmissao,
      valorTotal: notaFiscal.valorTotal,
      cnpjEmitente: notaFiscal.cnpjEmitente,
      razaoSocialEmitente: notaFiscal.razaoSocialEmitente,
      cnpjDestinatario: notaFiscal.cnpjDestinatario,
      chaveAcesso: notaFiscal.chaveAcesso,
      conciliado: false,
    );
    notasFiscais.add(novaNotaFiscal);
  }

  void atualizarNotaFiscal(String id, NotaFiscal notaFiscal) {
    final index = notasFiscais.indexWhere((nf) => nf.id == id);
    if (index != -1) {
      notasFiscais[index] = notaFiscal;
    }
  }

  void removerNotaFiscal(String id) {
    notasFiscais.removeWhere((nf) => nf.id == id);
  }
  
  // Filtros
  List<Transacao> get transacoesFiltradas {
    var lista = transacoes.toList();
    
    if (filtroTipo.value != 'TODOS') {
      lista = lista.where((t) => t.tipo.toString().split('.').last == filtroTipo.value).toList();
    }
    
    if (showApenasPendentes.value) {
      lista = lista.where((t) => t.conciliado == false).toList();
    }
    
    return lista;
  }
  
    List<Despesa> get despesasFiltradas {
  
      var lista = despesas.toList();
  
      
  
      if (showApenasPendentes.value) {
  
        lista = lista.where((d) => d.conciliado == false).toList();
  
      }
  
      
  
      return lista;
  
    }
  
    
  
    List<NotaFiscal> get notasFiscaisFiltradas {
  
      var lista = notasFiscais.toList();
  
      
  
      if (filtroTipo.value != 'TODOS') {
  
        lista = lista.where((nf) => nf.tipo.toString().split('.').last == filtroTipo.value).toList();
  
      }
  
      
  
      if (showApenasPendentes.value) {
  
        lista = lista.where((nf) => nf.conciliado == false).toList();
  
      }
  
      
  
      return lista;
  
    }
  
    
  
    // Cálculos
  
    double get saldoTotal {
  
      return transacoes.fold(0.0, (sum, t) => sum + t.valor);
  
    }
  
    
  
    double get totalDespesas {
  
      return despesas.fold(0.0, (sum, d) => sum + d.valor);
  
    }
  
    
  
    double get totalReceitas {
  
      return transacoes
  
          .where((t) => t.tipo == TipoTransacao.receita)
  
          .fold(0.0, (sum, t) => sum + t.valor);
  
        }
    
      List<FluxoCaixaData> get dadosFluxoCaixaMensal {
        final Map<String, FluxoCaixaData> fluxoCaixaMap = {};
    
        // Processar transações
        for (var transacao in transacoes) {
          final mes = DateFormat('yyyy-MM').format(transacao.data);
                fluxoCaixaMap.putIfAbsent(
                    mes,
                    () => FluxoCaixaData(
                          mes: mes,
                          entradasProg: 0,
                          entradasPrev: 0,
                          saidasProg: 0,
                          saidasPrev: 0,
                          saldoPrev: 0,
                        ));
          
                if (transacao.tipo == TipoTransacao.receita) {
                  if (transacao.conciliado) {
                    fluxoCaixaMap[mes]!.entradasProg += transacao.valor;
                  } else {
                    fluxoCaixaMap[mes]!.entradasPrev += transacao.valor;
                  }
                } else {
                  // Considerar despesas da lista de transações
                  if (transacao.conciliado) {
                    fluxoCaixaMap[mes]!.saidasProg += transacao.valor.abs();
                  } else {
                    fluxoCaixaMap[mes]!.saidasPrev += transacao.valor.abs();
                  }
                }
              }    
        // Ordenar por mês e calcular saldo acumulado
        final List<FluxoCaixaData> dadosOrdenados = fluxoCaixaMap.values.toList()
          ..sort((a, b) => a.mes.compareTo(b.mes));
    
        double saldoAcumulado = 0;
        for (int i = 0; i < dadosOrdenados.length; i++) {
          final item = dadosOrdenados[i];
          saldoAcumulado += (item.entradasProg + item.entradasPrev) -
              (item.saidasProg + item.saidasPrev);
          dadosOrdenados[i] = FluxoCaixaData(
            mes: item.mes,
            entradasProg: item.entradasProg,
            entradasPrev: item.entradasPrev,
            saidasProg: item.saidasProg,
            saidasPrev: item.saidasPrev,
            saldoPrev: saldoAcumulado,
          );
        }
    
        return dadosOrdenados;
      }
    }