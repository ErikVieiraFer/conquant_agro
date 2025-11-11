import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/almoxarifado.dart';
import '../../../data/models/almoxarifado_entrada.dart';
import '../../controllers/almoxarifado_controller.dart';

class AlmoxarifadoEntradaFormScreen extends StatefulWidget {
  const AlmoxarifadoEntradaFormScreen({super.key});

  @override
  State<AlmoxarifadoEntradaFormScreen> createState() =>
      _AlmoxarifadoEntradaFormScreenState();
}

class _AlmoxarifadoEntradaFormScreenState
    extends State<AlmoxarifadoEntradaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<AlmoxarifadoController>();
  final formatDate = DateFormat('dd/MM/yyyy');

  final _quantidadeController = TextEditingController();
  final _valorUnitarioController = TextEditingController();
  final _observacaoController = TextEditingController();
  final _fornecedorController = TextEditingController();
  final _notaFiscalController = TextEditingController();

  DateTime _dataSelecionada = DateTime.now();
  Almoxarifado? _materialSelecionado;

  @override
  void initState() {
    super.initState();

    // Recebe material como argumento (opcional)
    if (Get.arguments != null && Get.arguments is Almoxarifado) {
      _materialSelecionado = Get.arguments as Almoxarifado;
    }
  }

  @override
  void dispose() {
    _quantidadeController.dispose();
    _valorUnitarioController.dispose();
    _observacaoController.dispose();
    _fornecedorController.dispose();
    _notaFiscalController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  double get _valorTotal {
    final quantidade = double.tryParse(_quantidadeController.text) ?? 0.0;
    final valorUnitario = double.tryParse(_valorUnitarioController.text) ?? 0.0;
    return quantidade * valorUnitario;
  }

  Future<void> _registrarEntrada() async {
    if (!_formKey.currentState!.validate()) return;

    if (_materialSelecionado == null) {
      Get.snackbar(
        'Erro',
        'Selecione um material',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final entrada = AlmoxarifadoEntrada(
      propriedadeId: controller.propriedadeIdAtual.value,
      almoxarifadoId: _materialSelecionado!.id!,
      quantidade: double.parse(_quantidadeController.text),
      valorUnitario: double.parse(_valorUnitarioController.text),
      dataEntrada: _dataSelecionada,
      observacao: _observacaoController.text.trim().isNotEmpty
          ? _observacaoController.text.trim()
          : null,
      fornecedor: _fornecedorController.text.trim().isNotEmpty
          ? _fornecedorController.text.trim()
          : null,
      notaFiscal: _notaFiscalController.text.trim().isNotEmpty
          ? _notaFiscalController.text.trim()
          : null,
    );

    final sucesso = await controller.registrarEntrada(entrada);

    if (sucesso) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Entrada'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Seleção de Material
            if (_materialSelecionado == null)
              DropdownButtonFormField<Almoxarifado>(
                decoration: const InputDecoration(
                  labelText: 'Material *',
                  border: OutlineInputBorder(),
                ),
                value: _materialSelecionado,
                items: controller.materiais.map((material) {
                  return DropdownMenuItem(
                    value: material,
                    child: Text('${material.nome} (${material.unidade})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _materialSelecionado = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecione um material';
                  }
                  return null;
                },
              )
            else
              Card(
                child: ListTile(
                  title: Text(_materialSelecionado!.nome),
                  subtitle: Text(
                    'Unidade: ${_materialSelecionado!.unidade} | Sistema: ${_materialSelecionado!.sistemaDescricao}',
                  ),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              ),
            const SizedBox(height: 16),

            // Data de Entrada
            InkWell(
              onTap: _selecionarData,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data de Entrada *',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(formatDate.format(_dataSelecionada)),
              ),
            ),
            const SizedBox(height: 16),

            // Quantidade
            TextFormField(
              controller: _quantidadeController,
              decoration: InputDecoration(
                labelText: 'Quantidade *',
                hintText: '0.00',
                suffixText: _materialSelecionado?.unidade ?? '',
                border: const OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Quantidade é obrigatória';
                }
                final quantidade = double.tryParse(value);
                if (quantidade == null || quantidade <= 0) {
                  return 'Quantidade deve ser maior que zero';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Valor Unitário
            TextFormField(
              controller: _valorUnitarioController,
              decoration: const InputDecoration(
                labelText: 'Valor Unitário *',
                hintText: '0.00',
                prefixText: 'R\$ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Valor unitário é obrigatório';
                }
                final valor = double.tryParse(value);
                if (valor == null || valor <= 0) {
                  return 'Valor deve ser maior que zero';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Valor Total (calculado)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha((255 * 0.1).round()),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withAlpha((255 * 0.3).round())),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Valor Total:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                        .format(_valorTotal),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Fornecedor
            TextFormField(
              controller: _fornecedorController,
              decoration: const InputDecoration(
                labelText: 'Fornecedor',
                hintText: 'Nome do fornecedor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Nota Fiscal
            TextFormField(
              controller: _notaFiscalController,
              decoration: const InputDecoration(
                labelText: 'Nota Fiscal',
                hintText: 'Número da nota fiscal',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Observação
            TextFormField(
              controller: _observacaoController,
              decoration: const InputDecoration(
                labelText: 'Observação',
                hintText: 'Informações adicionais',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Botão Salvar
            Obx(() => ElevatedButton.icon(
                  onPressed:
                      controller.isLoading.value ? null : _registrarEntrada,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                  ),
                  icon: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check),
                  label: const Text('Registrar Entrada'),
                )),
          ],
        ),
      ),
    );
  }
}
