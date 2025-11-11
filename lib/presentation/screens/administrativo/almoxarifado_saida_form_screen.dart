import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/almoxarifado.dart';
import '../../../data/models/almoxarifado_saida.dart';
import '../../controllers/almoxarifado_controller.dart';

class AlmoxarifadoSaidaFormScreen extends StatefulWidget {
  const AlmoxarifadoSaidaFormScreen({super.key});

  @override
  State<AlmoxarifadoSaidaFormScreen> createState() =>
      _AlmoxarifadoSaidaFormScreenState();
}

class _AlmoxarifadoSaidaFormScreenState
    extends State<AlmoxarifadoSaidaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<AlmoxarifadoController>();
  final formatDate = DateFormat('dd/MM/yyyy');

  final _quantidadeController = TextEditingController();
  final _observacaoController = TextEditingController();
  final _destinoController = TextEditingController();

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
    _observacaoController.dispose();
    _destinoController.dispose();
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

  double? get _valorEstimado {
    if (_materialSelecionado == null) return null;

    final quantidade = double.tryParse(_quantidadeController.text) ?? 0.0;
    return quantidade * _materialSelecionado!.custoMedio;
  }

  Future<void> _registrarSaida() async {
    if (!_formKey.currentState!.validate()) return;

    if (_materialSelecionado == null) {
      Get.snackbar(
        'Erro',
        'Selecione um material',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final quantidade = double.parse(_quantidadeController.text);

    // Validar se há estoque disponível
    if (quantidade > _materialSelecionado!.estoqueDisponivel) {
      Get.snackbar(
        'Erro',
        'Quantidade solicitada (${quantidade.toStringAsFixed(2)}) maior que estoque disponível (${_materialSelecionado!.estoqueDisponivel.toStringAsFixed(2)})',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    final saida = AlmoxarifadoSaida(
      propriedadeId: controller.propriedadeIdAtual.value,
      almoxarifadoId: _materialSelecionado!.id!,
      quantidade: quantidade,
      dataSaida: _dataSelecionada,
      observacao: _observacaoController.text.trim().isNotEmpty
          ? _observacaoController.text.trim()
          : null,
      destino: _destinoController.text.trim().isNotEmpty
          ? _destinoController.text.trim()
          : null,
    );

    final sucesso = await controller.registrarSaida(saida);

    if (sucesso) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Saída'),
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Unidade: ${_materialSelecionado!.unidade}'),
                      Text(
                        'Sistema: ${_materialSelecionado!.sistemaDescricao}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _materialSelecionado!.sistema ==
                                  SistemaEstoque.peps
                              ? Colors.blue
                              : Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha((255 * 0.1).round()),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Text(
                          'Estoque: ${_materialSelecionado!.estoqueDisponivel.toStringAsFixed(2)} ${_materialSelecionado!.unidade}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              ),
            const SizedBox(height: 16),

            // Data de Saída
            InkWell(
              onTap: _selecionarData,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data de Saída *',
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
                helperText: _materialSelecionado != null
                    ? 'Disponível: ${_materialSelecionado!.estoqueDisponivel.toStringAsFixed(2)} ${_materialSelecionado!.unidade}'
                    : null,
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
                if (_materialSelecionado != null &&
                    quantidade > _materialSelecionado!.estoqueDisponivel) {
                  return 'Quantidade maior que estoque disponível';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Valor Estimado (calculado com custo médio)
            if (_materialSelecionado != null && _valorEstimado != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha((255 * 0.1).round()),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withAlpha((255 * 0.3).round())),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Valor Estimado:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                              .format(_valorEstimado),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Baseado no custo médio de ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(_materialSelecionado!.custoMedio)}/${_materialSelecionado!.unidade}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: _materialSelecionado!.sistema ==
                                    SistemaEstoque.peps
                                ? Colors.blue
                                : Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _materialSelecionado!.sistema ==
                                      SistemaEstoque.peps
                                  ? 'Sistema PEPS: Consumirá os lotes mais antigos primeiro'
                                  : 'Sistema UEPS: Consumirá os lotes mais recentes primeiro',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Destino
            TextFormField(
              controller: _destinoController,
              decoration: const InputDecoration(
                labelText: 'Destino',
                hintText: 'Ex: Pasto A, Setor 3, Gado de Corte',
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
                  onPressed: controller.isLoading.value ? null : _registrarSaida,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.error,
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
                      : const Icon(Icons.output),
                  label: const Text('Registrar Saída'),
                )),
          ],
        ),
      ),
    );
  }
}
