import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/conciliacao.dart';
import '../../../data/models/transacao.dart';
import '../../../data/models/nota_fiscal.dart';
import '../../controllers/conciliacao_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_drawer.dart';

class ConciliacaoScreen extends StatefulWidget {
  const ConciliacaoScreen({super.key});

  @override
  State<ConciliacaoScreen> createState() => _ConciliacaoScreenState();
}

class _ConciliacaoScreenState extends State<ConciliacaoScreen> {
  late final ConciliacaoController controller;
  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ConciliacaoController());
    authController = Get.find<AuthController>();

    // Carregar dados ao iniciar
    Future.delayed(Duration.zero, () {
      if (authController.propriedadeAtual.value != null) {
        controller.carregarDadosConciliacao(
          authController.propriedadeAtual.value!.id!,
          DateTime.now().month,
          DateTime.now().year,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conciliação'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selecionarPeriodo(context, controller),
            tooltip: 'Selecionar Período',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _mostrarAjuda(context),
            tooltip: 'Ajuda',
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Card de resumo do período
            _buildResumoCard(controller),

            // Tabs para as etapas
            _buildTabBar(controller),

            // Conteúdo da etapa atual
            Expanded(
              child: Obx(() {
                if (controller.etapaAtual.value == 1) {
                  return _ConciliacaoBancariaTab(controller: controller);
                } else {
                  return _ConciliacaoFiscalTab(controller: controller);
                }
              }),
            ),

            // Botões de ação
            _buildBotoesAcao(controller),
          ],
        );
      }),
    );
  }
}

Widget _buildResumoCard(ConciliacaoController controller) {
  final formatCurrency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  return Obx(() {
    final conciliacao = controller.conciliacaoAtual.value;
    if (conciliacao == null) return const SizedBox.shrink();

    final saldoCalculado = conciliacao.saldoCalculado ?? 0.0;
    final isSaldoZerado = conciliacao.isSaldoZerado;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSaldoZerado
            ? Colors.green.withAlpha((255 * 0.1).round())
            : AppColors.primary.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSaldoZerado
              ? Colors.green.withAlpha((255 * 0.3).round())
              : AppColors.primary.withAlpha((255 * 0.3).round()),
        ),
      ),
      child: Column(
        children: [
          Text(
            conciliacao.periodoFormatado,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getStatusDescricao(conciliacao.status),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Saldo da Conciliação',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatCurrency.format(saldoCalculado.abs()),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isSaldoZerado ? Colors.green : AppColors.despesa,
            ),
          ),
          if (isSaldoZerado)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Saldo zerado',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  });
}

Widget _buildTabBar(ConciliacaoController controller) {
  return Obx(() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).round()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'Bancária',
              icon: Icons.account_balance,
              isActive: controller.etapaAtual.value == 1,
              onTap: () => controller.voltarParaEtapa1(),
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'Fiscal',
              icon: Icons.description,
              isActive: controller.etapaAtual.value == 2,
              onTap: () => controller.avancarParaEtapa2(),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildBotoesAcao(ConciliacaoController controller) {
  return Obx(() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).round()),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (controller.etapaAtual.value == 1)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.isSaldoZerado
                    ? () => controller.avancarParaEtapa2()
                    : null,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Avançar para Fiscal'),
              ),
            ),
          if (controller.etapaAtual.value == 2) ...[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => controller.voltarParaEtapa1(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Voltar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => controller.finalizarConciliacao(),
                icon: const Icon(Icons.check),
                label: const Text('Finalizar'),
              ),
            ),
          ],
        ],
      ),
    );
  });
}

String _getStatusDescricao(StatusConciliacao status) {
  switch (status) {
    case StatusConciliacao.pendente:
      return 'Pendente';
    case StatusConciliacao.emAndamento:
      return 'Em Andamento';
    case StatusConciliacao.concluida:
      return 'Concluída';
    case StatusConciliacao.cancelada:
      return 'Cancelada';
  }
}

Future<void> _selecionarPeriodo(
    BuildContext context, ConciliacaoController controller) async {
  final authController = Get.find<AuthController>();
  if (authController.propriedadeAtual.value == null) return;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Selecionar Período'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Em desenvolvimento...'),
          const SizedBox(height: 16),
          Text(
            'Período atual: ${controller.mesAtual.value}/${controller.anoAtual.value}',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    ),
  );
}

void _mostrarAjuda(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Ajuda - Conciliação'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ETAPA 1 - Conciliação Bancária',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• Vincule transações do extrato com despesas\n' 
              '• O saldo deve chegar a zero para avançar\n' 
              '• Selecione um extrato e uma despesa para criar vínculo',
            ),
            SizedBox(height: 16),
            Text(
              'ETAPA 2 - Conciliação Fiscal',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• Verifique o status das Notas Fiscais\n' 
              '• Use o botão CONCILIAR para validar cada nota\n' 
              '• Finalize quando todas estiverem validadas',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Entendi'),
        ),
      ],
    ),
  );
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Componente da Etapa 1 - Conciliação Bancária
class _ConciliacaoBancariaTab extends StatelessWidget {
  final ConciliacaoController controller;

  const _ConciliacaoBancariaTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final formatDate = DateFormat('dd/MM/yyyy');

    return Obx(() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vínculos já criados
            if (controller.vinculos.isNotEmpty) ...[
              const Text(
                'Vínculos Criados',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...controller.vinculos.map((vinculo) {
                final extrato = controller.extratos
                    .firstWhereOrNull((e) => e.id == vinculo.extratoId);
                final despesa = controller.despesas
                    .firstWhereOrNull((d) => d.id == vinculo.despesaId);

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.link, color: Colors.white, size: 20),
                    ),
                    title: Text(extrato?.descricao ?? 'Extrato não encontrado'),
                    subtitle: Text(despesa?.descricao ?? 'Despesa não encontrada'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.removerVinculo(vinculo.id!),
                    ),
                  ),
                );
              }),
              const Divider(height: 32),
            ],

            // Seção de criação de vínculo
            const Text(
              'Criar Novo Vínculo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Extrato selecionado
            const Text(
              'Selecione um Extrato:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            if (controller.extratoSelecionado.value != null)
              Card(
                color: AppColors.primary.withAlpha((255 * 0.1).round()),
                child: ListTile(
                  leading: const Icon(Icons.account_balance, color: AppColors.primary),
                  title: Text(controller.extratoSelecionado.value!.descricao),
                  subtitle: Text(
                    formatCurrency.format(controller.extratoSelecionado.value!.valor),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => controller.extratoSelecionado.value = null,
                  ),
                ),
              )
            else
              ...controller.extratosNaoVinculados.map((extrato) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: extrato.tipo == TipoTransacao.receita
                          ? Colors.green.withAlpha((255 * 0.1).round())
                          : Colors.red.withAlpha((255 * 0.1).round()),
                      child: Icon(
                        extrato.tipo == TipoTransacao.receita
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: extrato.tipo == TipoTransacao.receita
                            ? Colors.green
                            : Colors.red,
                        size: 20,
                      ),
                    ),
                    title: Text(extrato.descricao),
                    subtitle: Text(formatDate.format(extrato.data)),
                    trailing: Text(
                      formatCurrency.format(extrato.valor),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: extrato.tipo == TipoTransacao.receita
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    onTap: () => controller.selecionarExtrato(extrato),
                  ),
                );
              }),

            const SizedBox(height: 24),

            // Despesa selecionada
            const Text(
              'Selecione uma Despesa:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            if (controller.despesaSelecionada.value != null)
              Card(
                color: AppColors.despesa.withAlpha((255 * 0.1).round()),
                child: ListTile(
                  leading: const Icon(Icons.receipt, color: AppColors.despesa),
                  title: Text(controller.despesaSelecionada.value!.descricao),
                  subtitle: Text(
                    formatCurrency.format(controller.despesaSelecionada.value!.valor),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => controller.despesaSelecionada.value = null,
                  ),
                ),
              )
            else
              ...controller.despesasNaoVinculadas.map((despesa) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.despesa.withAlpha((255 * 0.1).round()),
                      child: const Icon(
                        Icons.receipt,
                        color: AppColors.despesa,
                        size: 20,
                      ),
                    ),
                    title: Text(despesa.descricao),
                    subtitle: Text(formatDate.format(despesa.data)),
                    trailing: Text(
                      formatCurrency.format(despesa.valor),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.despesa,
                      ),
                    ),
                    onTap: () => controller.selecionarDespesa(despesa),
                  ),
                );
              }),

            const SizedBox(height: 24),

            // Botão criar vínculo
            if (controller.extratoSelecionado.value != null &&
                controller.despesaSelecionada.value != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => controller.criarVinculo(),
                  icon: const Icon(Icons.link),
                  label: const Text('Criar Vínculo'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

// Componente da Etapa 2 - Conciliação Fiscal
class _ConciliacaoFiscalTab extends StatelessWidget {
  final ConciliacaoController controller;

  const _ConciliacaoFiscalTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final formatDate = DateFormat('dd/MM/yyyy');

    return Obx(() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumo
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    'Pendentes',
                    controller.notasFiscaisPendentes.length.toString(),
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    'Conciliadas',
                    controller.notasFiscaisConciliadas.length.toString(),
                    Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Notas Fiscais Pendentes
            if (controller.notasFiscaisPendentes.isNotEmpty) ...[
              const Text(
                'Notas Fiscais Pendentes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...controller.notasFiscaisPendentes.map((nf) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'NF ${nf.numero} - Série ${nf.serie}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    nf.razaoSocialEmitente,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(nf.status).withAlpha((255 * 0.1).round()),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                nf.statusDescricao,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _getStatusColor(nf.status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Emissão: ${formatDate.format(nf.dataEmissao)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatCurrency.format(nf.valorTotal),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () => controller.conciliarNotaFiscal(nf.id!),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('CONCILIAR'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],

            // Notas Fiscais Conciliadas
            if (controller.notasFiscaisConciliadas.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Notas Fiscais Conciliadas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...controller.notasFiscaisConciliadas.map((nf) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.check, color: Colors.white, size: 20),
                    ),
                    title: Text('NF ${nf.numero} - ${nf.razaoSocialEmitente}'),
                    subtitle: Text(formatDate.format(nf.dataEmissao)),
                    trailing: Text(
                      formatCurrency.format(nf.valorTotal),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),
            ],

            if (controller.notasFiscais.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Nenhuma nota fiscal encontrada para este período'),
                ),
              ),
          ],
        ),
      );
    });
  }
}

Widget _buildInfoCard(String label, String value, Color color) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withAlpha((255 * 0.1).round()),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withAlpha((255 * 0.3).round())),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    ),
  );
}

Color _getStatusColor(StatusNotaFiscal status) {
  switch (status) {
    case StatusNotaFiscal.aguardandoAutorizacao:
      return Colors.orange;
    case StatusNotaFiscal.autorizada:
      return Colors.blue;
    case StatusNotaFiscal.cancelada:
      return Colors.red;
    case StatusNotaFiscal.denegada:
      return Colors.red;
    case StatusNotaFiscal.contingencia:
      return Colors.amber;
    case StatusNotaFiscal.inutilizada:
      return Colors.grey;
    case StatusNotaFiscal.emProcessamento:
      return Colors.purple;
    case StatusNotaFiscal.conciliada:
      return Colors.green;
  }
}