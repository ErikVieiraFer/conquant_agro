import 'package:conquant_agro/data/models/transacao.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../controllers/financeiro_controller.dart';
import '../../../widgets/custom_date_picker.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/loading_overlay.dart';

class TransacaoForm extends StatefulWidget {
  final Transacao? transacao;

  const TransacaoForm({super.key, this.transacao});

  @override
  State<TransacaoForm> createState() => _TransacaoFormState();
}

class _TransacaoFormState extends State<TransacaoForm> {
  final _formKey = GlobalKey<FormState>();
  final _financeiroController = Get.find<FinanceiroController>();

  late final TextEditingController _dataController;
  late final TextEditingController _descricaoController;
  late final TextEditingController _valorController;
  late final TextEditingController _contaBancariaController;

  TipoTransacao? _tipoSelecionado;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dataController = TextEditingController(text: widget.transacao != null ? Formatters.date(widget.transacao!.data) : '');
    _descricaoController = TextEditingController(text: widget.transacao?.descricao ?? '');
    _valorController = TextEditingController(text: widget.transacao != null ? Formatters.currency(widget.transacao!.valor) : '');
    _contaBancariaController = TextEditingController(text: widget.transacao?.contaBancaria ?? '');
    _tipoSelecionado = widget.transacao?.tipo;
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      double valor = double.parse(_valorController.text.replaceAll('.', '').replaceAll(',', '.'));
      if (_tipoSelecionado == TipoTransacao.despesa && valor > 0) {
        valor = -valor;
      }
      if (_tipoSelecionado == TipoTransacao.receita && valor < 0) {
        valor = -valor;
      }

      final transacao = Transacao(
        id: widget.transacao?.id,
        data: DateFormat('dd/MM/yyyy').parse(_dataController.text),
        descricao: _descricaoController.text,
        valor: valor,
        tipo: _tipoSelecionado!,
        contaBancaria: _contaBancariaController.text,
      );

      try {
        if (widget.transacao == null) {
          _financeiroController.adicionarTransacao(transacao);
        } else {
          _financeiroController.atualizarTransacao(transacao.id!, transacao);
        }
        Get.back();
        Get.snackbar('Sucesso', 'Transação salva com sucesso!', snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar('Erro', 'Ocorreu um erro ao salvar a transação.', snackPosition: SnackPosition.BOTTOM);
      }

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.transacao == null ? 'Nova Transação' : 'Editar Transação')),
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
                CustomDropdown<TipoTransacao>(
                  labelText: 'Tipo',
                  items: TipoTransacao.values,
                  selectedItem: _tipoSelecionado,
                  onChanged: (tipo) => setState(() => _tipoSelecionado = tipo),
                  validator: (value) => value == null ? 'Campo obrigatório' : null,
                  itemAsString: (tipo) => tipo.toString().split('.').last,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _valorController,
                  labelText: 'Valor',
                  validator: Validators.required,
                  keyboardType: TextInputType.number,
                  inputFormatters: [Formatters.decimalInputFormatter],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _contaBancariaController,
                  labelText: 'Conta Bancária',
                  validator: Validators.required,
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