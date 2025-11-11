import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/models/conciliacao.dart';
import '../../data/models/transacao.dart';
import '../../data/models/vinculo.dart';
import '../../data/models/nota_fiscal.dart';
import '../../data/models/despesa.dart';
import 'package:conquant_agro/presentation/controllers/financeiro_controller.dart';

class ConciliacaoController extends GetxController {

  // Dados da conciliação
  var conciliacaoAtual = Rx<Conciliacao?>(null);
  var vinculos = <Vinculo>[].obs;
  var extratos = <Transacao>[].obs;
  var despesas = <Despesa>[].obs;
  var notasFiscais = <NotaFiscal>[].obs;

  // Controles de UI
  var isLoading = false.obs;
  var etapaAtual = 1.obs; // 1 = Bancária, 2 = Fiscal
  var mesAtual = DateTime.now().month.obs;
  var anoAtual = DateTime.now().year.obs;

  // Seleções para vinculação
  var extratoSelecionado = Rx<Transacao?>(null);
  var despesaSelecionada = Rx<Despesa?>(null);

  // Injeção de dependência do FinanceiroController
  final FinanceiroController _financeiroController = Get.find<FinanceiroController>();


  // ETAPA 1 - CONCILIAÇÃO BANCÁRIA

  Future<void> carregarDadosConciliacao(String propriedadeId, int mes, int ano) async {
    try {
      isLoading.value = true;
      mesAtual.value = mes;
      anoAtual.value = ano;

      // Carregar conciliação existente ou criar nova
      await _carregarConciliacao(propriedadeId, mes, ano);

      // Carregar extratos, despesas e vínculos
      await Future.wait([
        _carregarExtratos(propriedadeId, mes, ano),
        _carregarDespesas(propriedadeId, mes, ano),
        _carregarNotasFiscais(propriedadeId, mes, ano),
      ]);

      if (conciliacaoAtual.value != null) {
        await _carregarVinculos(conciliacaoAtual.value!.id!);
      }

      _calcularSaldos();
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao carregar dados: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _carregarConciliacao(String propriedadeId, int mes, int ano) async {
    // Por enquanto, criar uma conciliação local
    // Em produção, chamar: await _apiService.getConciliacao(propriedadeId, mes, ano);
    conciliacaoAtual.value = Conciliacao(
      id: 'conc_${propriedadeId}_${mes}_$ano',
      propriedadeId: propriedadeId,
      mes: mes,
      ano: ano,
      dataCriacao: DateTime.now(),
      status: StatusConciliacao.emAndamento,
    );
  }

  Future<void> _carregarExtratos(String propriedadeId, int mes, int ano) async {
    // Em produção: await _apiService.getExtrato(propriedadeId, mes: mes, ano: ano);
    // Por enquanto, usar dados do FinanceiroController
    extratos.value = _financeiroController.transacoes
        .where((t) => t.data.month == mes && t.data.year == ano && !t.conciliado)
        .toList();
  }

  Future<void> _carregarDespesas(String propriedadeId, int mes, int ano) async {
    // Em produção: await _apiService.getDespesas(propriedadeId, mes: mes, ano: ano);
    // Por enquanto, usar dados do FinanceiroController
    despesas.value = _financeiroController.despesas
        .where((d) => d.data.month == mes && d.data.year == ano && !d.conciliado)
        .toList();
  }

  Future<void> _carregarNotasFiscais(String propriedadeId, int mes, int ano) async {
    // Em produção: await _apiService.getNotasFiscais(propriedadeId, mes: mes, ano: ano);
    // Por enquanto, usar dados do FinanceiroController
    notasFiscais.value = _financeiroController.notasFiscais
        .where((nf) => nf.dataEmissao.month == mes && nf.dataEmissao.year == ano)
        .toList();
  }

  Future<void> _carregarVinculos(String conciliacaoId) async {
    // Em produção: await _apiService.getVinculos(conciliacaoId);
    vinculos.clear();
  }

  void selecionarExtrato(Transacao extrato) {
    extratoSelecionado.value = extrato;
  }

  void selecionarDespesa(Despesa despesa) {
    despesaSelecionada.value = despesa;
  }

  Future<void> criarVinculo() async {
    if (extratoSelecionado.value == null || despesaSelecionada.value == null) {
      Get.snackbar('Atenção', 'Selecione um extrato e uma despesa',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (conciliacaoAtual.value == null) {
      Get.snackbar('Erro', 'Nenhuma conciliação ativa',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;

      final vinculo = Vinculo(
        id: 'vinc_${DateTime.now().millisecondsSinceEpoch}',
        propriedadeId: conciliacaoAtual.value!.propriedadeId,
        extratoId: extratoSelecionado.value!.id!,
        despesaId: despesaSelecionada.value!.id!,
        conciliacaoId: conciliacaoAtual.value!.id!,
        dataCriacao: DateTime.now(),
        valor: extratoSelecionado.value!.valor,
      );

      // Em produção: await _apiService.criarVinculo(vinculo.toJson());
      vinculos.add(vinculo);

      // Limpar seleções
      extratoSelecionado.value = null;
      despesaSelecionada.value = null;

      _calcularSaldos();

      Get.snackbar('Sucesso', 'Vínculo criado com sucesso',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao criar vínculo: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removerVinculo(String vinculoId) async {
    try {
      isLoading.value = true;

      // Em produção: await _apiService.deletarVinculo(vinculoId);
      vinculos.removeWhere((v) => v.id == vinculoId);

      _calcularSaldos();

      Get.snackbar('Sucesso', 'Vínculo removido com sucesso',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao remover vínculo: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void _calcularSaldos() {
    if (conciliacaoAtual.value == null) return;

    // Calcular saldo total dos extratos
    double saldoExtratos = extratos.fold(0.0, (sum, e) {
      return sum + (e.tipo == TipoTransacao.receita ? e.valor : -e.valor);
    });

    // Calcular saldo total das despesas
    double saldoDespesas = despesas.fold(0.0, (sum, d) => sum + d.valor);

    // Saldo calculado = saldoExtratos - saldoDespesas
    double saldoCalculado = saldoExtratos - saldoDespesas;

    conciliacaoAtual.value = conciliacaoAtual.value!.copyWith(
      saldoInicial: saldoExtratos,
      saldoFinal: saldoDespesas,
      saldoCalculado: saldoCalculado,
    );
  }

  // Getters para items não vinculados
  List<Transacao> get extratosNaoVinculados {
    final vinculadosIds = vinculos.map((v) => v.extratoId).toSet();
    return extratos.where((e) => !vinculadosIds.contains(e.id)).toList();
  }

  List<Despesa> get despesasNaoVinculadas {
    final vinculadosIds = vinculos.map((v) => v.despesaId).toSet();
    return despesas.where((d) => !vinculadosIds.contains(d.id)).toList();
  }

  bool get isSaldoZerado {
    return conciliacaoAtual.value?.isSaldoZerado ?? false;
  }

  // ETAPA 2 - CONCILIAÇÃO FISCAL

  void avancarParaEtapa2() {
    if (!isSaldoZerado) {
      Get.snackbar(
        'Atenção',
        'O saldo da conciliação bancária deve ser zerado antes de avançar',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    etapaAtual.value = 2;
  }

  void voltarParaEtapa1() {
    etapaAtual.value = 1;
  }

  List<NotaFiscal> get notasFiscaisPendentes {
    return notasFiscais.where((nf) => nf.status != StatusNotaFiscal.conciliada).toList();
  }

  List<NotaFiscal> get notasFiscaisConciliadas {
    return notasFiscais.where((nf) => nf.status == StatusNotaFiscal.conciliada).toList();
  }

  Future<void> conciliarNotaFiscal(String notaFiscalId) async {
    try {
      isLoading.value = true;

      // Em produção: await _apiService.atualizarStatusNotaFiscal(notaFiscalId, 7);

      final index = notasFiscais.indexWhere((nf) => nf.id == notaFiscalId);
      if (index != -1) {
        notasFiscais[index] = notasFiscais[index].copyWith(
          status: StatusNotaFiscal.conciliada,
          conciliado: true,
        );
      }

      Get.snackbar('Sucesso', 'Nota fiscal conciliada com sucesso',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao conciliar nota fiscal: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> atualizarStatusNotaFiscal(String notaFiscalId, StatusNotaFiscal novoStatus) async {
    try {
      isLoading.value = true;

      // Em produção: await _apiService.atualizarStatusNotaFiscal(notaFiscalId, novoStatus.index);

      final index = notasFiscais.indexWhere((nf) => nf.id == notaFiscalId);
      if (index != -1) {
        notasFiscais[index] = notasFiscais[index].copyWith(status: novoStatus);
      }

      Get.snackbar('Sucesso', 'Status atualizado com sucesso',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao atualizar status: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> finalizarConciliacao() async {
    if (!isSaldoZerado) {
      Get.snackbar(
        'Atenção',
        'O saldo da conciliação bancária deve ser zerado antes de finalizar',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (notasFiscaisPendentes.isNotEmpty) {
      final confirmar = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Confirmação'),
          content: Text(
            'Existem ${notasFiscaisPendentes.length} notas fiscais pendentes. Deseja continuar?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );

      if (confirmar != true) return;
    }

    try {
      isLoading.value = true;

      conciliacaoAtual.value = conciliacaoAtual.value!.copyWith(
        status: StatusConciliacao.concluida,
        dataFinalizacao: DateTime.now(),
      );

      // Em produção: await _apiService.atualizarConciliacao(
      //   conciliacaoAtual.value!.id!,
      //   conciliacaoAtual.value!.toJson(),
      // );

      Get.snackbar('Sucesso', 'Conciliação finalizada com sucesso',
          snackPosition: SnackPosition.BOTTOM);

      Get.back(); // Voltar para tela anterior
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao finalizar conciliação: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
