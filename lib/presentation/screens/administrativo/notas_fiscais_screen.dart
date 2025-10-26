import 'package:conquant_agro/data/models/nota_fiscal.dart';
import 'package:conquant_agro/presentation/screens/administrativo/forms/nota_fiscal_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/financeiro_controller.dart';
import '../../widgets/custom_drawer.dart';

class NotasFiscaisScreen extends StatelessWidget {
  const NotasFiscaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FinanceiroController());
    final formatCurrency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final formatDate = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas Fiscais'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'importar_xml':
                  Get.snackbar(
                    'Em desenvolvimento',
                    'Importar XML da NF-e',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  break;
                case 'filtros':
                  _mostrarFiltros(context, controller);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'importar_xml',
                child: Row(
                  children: [
                    Icon(Icons.upload_file),
                    SizedBox(width: 12),
                    Text('Importar XML'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'filtros',
                child: Row(
                  children: [
                    Icon(Icons.filter_list),
                    SizedBox(width: 12),
                    Text('Filtros'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          // Filtro rápido Entrada/Saída
          Obx(() => Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildFiltroChip(
                        'TODOS',
                        'Todos',
                        controller.filtroTipo.value == 'TODOS',
                        () => controller.filtroTipo.value = 'TODOS',
                      ),
                    ),
                    Expanded(
                      child: _buildFiltroChip(
                        'entrada',
                        'Entradas',
                        controller.filtroTipo.value == 'entrada',
                        () => controller.filtroTipo.value = 'entrada',
                      ),
                    ),
                    Expanded(
                      child: _buildFiltroChip(
                        'saida',
                        'Saídas',
                        controller.filtroTipo.value == 'saida',
                        () => controller.filtroTipo.value = 'saida',
                      ),
                    ),
                  ],
                ),
              )),

          // Lista de Notas Fiscais
          Expanded(
            child: Obx(() {
              final notasFiscais = controller.notasFiscaisFiltradas;

              if (notasFiscais.isEmpty) {
                return const Center(
                  child: Text('Nenhuma nota fiscal encontrada'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: notasFiscais.length,
                itemBuilder: (context, index) {
                  final nf = notasFiscais[index];
                  final isEntrada = nf.tipo == TipoNotaFiscal.entrada;
                  final valor = nf.valorTotal;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: isEntrada
                            ? AppColors.receita.withOpacity(0.1)
                            : AppColors.despesa.withOpacity(0.1),
                        child: Icon(
                          isEntrada ? Icons.call_received : Icons.call_made,
                          color: isEntrada ? AppColors.receita : AppColors.despesa,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        'NF ${nf.numero} - Série ${nf.serie}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            formatDate.format(nf.dataEmissao),
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isEntrada
                                ? 'Para: ${nf.cnpjDestinatario ?? 'N/A'}'
                                : 'De: ${nf.razaoSocialEmitente}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            nf.tipo.toString().split('.').last,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isEntrada ? AppColors.receita : AppColors.despesa,
                            ),
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              formatCurrency.format(valor),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isEntrada ? AppColors.receita : AppColors.despesa,
                              ),
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow('Emitente:', nf.razaoSocialEmitente),
                              _buildInfoRow('CNPJ Emitente:', nf.cnpjEmitente),
                              _buildInfoRow('Destinatário:', nf.cnpjDestinatario ?? 'N/A'),
                              _buildInfoRow(
                                'Chave de Acesso:',
                                nf.chaveAcesso ?? 'N/A',
                                mono: true,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        Get.snackbar(
                                          'Em desenvolvimento',
                                          'Visualizar PDF da nota',
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      },
                                      icon: const Icon(Icons.picture_as_pdf, size: 18),
                                      label: const Text('Ver PDF'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Get.to(() => NotaFiscalForm(notaFiscal: nf));
                                      },
                                      icon: const Icon(Icons.edit, size: 18),
                                      label: const Text('Editar'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const NotaFiscalForm());
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova NF'),
      ),
    );
  }

  Widget _buildFiltroChip(
    String value,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool mono = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontFamily: mono ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarFiltros(BuildContext context, FinanceiroController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filtros Avançados',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'Em desenvolvimento',
                    'Filtro por período será implementado',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text('Filtrar por Período'),
              ),
            ],
          ),
        );
      },
    );
  }
}
