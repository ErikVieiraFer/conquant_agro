import 'package:conquant_agro/data/models/natureza.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../data/models/despesa.dart';
import '../../../controllers/financeiro_controller.dart';
import '../../../widgets/custom_date_picker.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/loading_overlay.dart';

class DespesaForm extends StatefulWidget {
  final Despesa? despesa;

  const DespesaForm({super.key, this.despesa});

  @override
  State<DespesaForm> createState() => _DespesaFormState();
}

class _DespesaFormState extends State<DespesaForm> {
  final _formKey = GlobalKey<FormState>();
  final _financeiroController = Get.find<FinanceiroController>();

  late final TextEditingController _dataController;
  late final TextEditingController _descricaoController;
  late final TextEditingController _valorController;
  late final TextEditingController _observacaoController;

  Natureza? _naturezaSelecionada;
  FinalidadeDespesa? _finalidadeSelecionada;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dataController = TextEditingController(text: widget.despesa != null ? Formatters.date(widget.despesa!.data) : '');
    _descricaoController = TextEditingController(text: widget.despesa?.descricao ?? '');
    _valorController = TextEditingController(text: widget.despesa != null ? Formatters.currency(widget.despesa!.valor) : '');
    _observacaoController = TextEditingController(text: widget.despesa?.observacao ?? '');
    _naturezaSelecionada = widget.despesa != null ? _financeiroController.naturezas.firstWhere((n) => n.nome == widget.despesa!.natureza) : null;
    _finalidadeSelecionada = widget.despesa?.finalidade;
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final despesa = Despesa(
        id: widget.despesa?.id,
        data: DateFormat('dd/MM/yyyy').parse(_dataController.text),
        descricao: _descricaoController.text,
        valor: double.parse(_valorController.text.replaceAll('.', '').replaceAll(',', '.')),
        natureza: _naturezaSelecionada!.nome,
        finalidade: _finalidadeSelecionada!,
        observacao: _observacaoController.text,
      );

      try {
        if (widget.despesa == null) {
          _financeiroController.adicionarDespesa(despesa);
        } else {
          _financeiroController.atualizarDespesa(despesa.id!, despesa);
        }
        Get.back();
        Get.snackbar('Sucesso', 'Despesa salva com sucesso!', snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar('Erro', 'Ocorreu um erro ao salvar a despesa.', snackPosition: SnackPosition.BOTTOM);
      }

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.despesa == null ? 'Nova Despesa' : 'Editar Despesa')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomDatePicker(
                  controller: _dataController,
                  labelText: 'Data',
                  validator: Validators.required,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descricaoController,
                  labelText: 'Descrição',
                  validator: Validators.required,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _valorController,
                  labelText: 'Valor',
                  validator: Validators.positiveNumber,
                  keyboardType: TextInputType.number,
                  inputFormatters: [Formatters.decimalInputFormatter],
                ),
                const SizedBox(height: 16),
                CustomDropdown<Natureza>(
                  labelText: 'Natureza',
                  items: _financeiroController.naturezas,
                  selectedItem: _naturezaSelecionada,
                  onChanged: (natureza) => setState(() => _naturezaSelecionada = natureza),
                  validator: (value) => value == null ? 'Campo obrigatório' : null,
                  itemAsString: (natureza) => natureza.nome,
                ),
                const SizedBox(height: 16),
                CustomDropdown<FinalidadeDespesa>(
                  labelText: 'Finalidade',
                  items: FinalidadeDespesa.values,
                  selectedItem: _finalidadeSelecionada,
                  onChanged: (finalidade) => setState(() => _finalidadeSelecionada = finalidade),
                  validator: (value) => value == null ? 'Campo obrigatório' : null,
                  itemAsString: (finalidade) => finalidade.toString().split('.').last,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _observacaoController,
                  labelText: 'Observação (opcional)',
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _salvar,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Salvar'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}