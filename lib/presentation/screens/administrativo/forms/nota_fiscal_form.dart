import 'package:conquant_agro/data/models/nota_fiscal.dart';
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

class NotaFiscalForm extends StatefulWidget {
  final NotaFiscal? notaFiscal;

  const NotaFiscalForm({super.key, this.notaFiscal});

  @override
  State<NotaFiscalForm> createState() => _NotaFiscalFormState();
}

class _NotaFiscalFormState extends State<NotaFiscalForm> {
  final _formKey = GlobalKey<FormState>();
  final _financeiroController = Get.find<FinanceiroController>();

  late final TextEditingController _dataEmissaoController;
  late final TextEditingController _numeroController;
  late final TextEditingController _serieController;
  late final TextEditingController _valorTotalController;
  late final TextEditingController _cnpjEmitenteController;
  late final TextEditingController _razaoSocialEmitenteController;
  late final TextEditingController _cnpjDestinatarioController;
  late final TextEditingController _chaveAcessoController;

  TipoNotaFiscal? _tipoSelecionado;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dataEmissaoController = TextEditingController(text: widget.notaFiscal != null ? Formatters.date(widget.notaFiscal!.dataEmissao) : '');
    _numeroController = TextEditingController(text: widget.notaFiscal?.numero ?? '');
    _serieController = TextEditingController(text: widget.notaFiscal?.serie ?? '');
    _valorTotalController = TextEditingController(text: widget.notaFiscal != null ? Formatters.currency(widget.notaFiscal!.valorTotal) : '');
    _cnpjEmitenteController = TextEditingController(text: widget.notaFiscal?.cnpjEmitente ?? '');
    _razaoSocialEmitenteController = TextEditingController(text: widget.notaFiscal?.razaoSocialEmitente ?? '');
    _cnpjDestinatarioController = TextEditingController(text: widget.notaFiscal?.cnpjDestinatario ?? '');
    _chaveAcessoController = TextEditingController(text: widget.notaFiscal?.chaveAcesso ?? '');
    _tipoSelecionado = widget.notaFiscal?.tipo;
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final notaFiscal = NotaFiscal(
        id: widget.notaFiscal?.id,
        tipo: _tipoSelecionado!,
        numero: _numeroController.text,
        serie: _serieController.text,
        dataEmissao: DateFormat('dd/MM/yyyy').parse(_dataEmissaoController.text),
        valorTotal: double.parse(_valorTotalController.text.replaceAll('.', '').replaceAll(',', '.')),
        cnpjEmitente: _cnpjEmitenteController.text,
        razaoSocialEmitente: _razaoSocialEmitenteController.text,
        cnpjDestinatario: _cnpjDestinatarioController.text,
        chaveAcesso: _chaveAcessoController.text,
      );

      try {
        if (widget.notaFiscal == null) {
          _financeiroController.adicionarNotaFiscal(notaFiscal);
        } else {
          _financeiroController.atualizarNotaFiscal(notaFiscal.id!, notaFiscal);
        }
        Get.back();
        Get.snackbar('Sucesso', 'Nota Fiscal salva com sucesso!', snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar('Erro', 'Ocorreu um erro ao salvar a Nota Fiscal.', snackPosition: SnackPosition.BOTTOM);
      }

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.notaFiscal == null ? 'Nova Nota Fiscal' : 'Editar Nota Fiscal')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomDropdown<TipoNotaFiscal>(
                  labelText: 'Tipo',
                  items: TipoNotaFiscal.values,
                  selectedItem: _tipoSelecionado,
                  onChanged: (tipo) => setState(() => _tipoSelecionado = tipo),
                  validator: (value) => value == null ? 'Campo obrigatório' : null,
                  itemAsString: (tipo) => tipo.toString().split('.').last,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _numeroController,
                  labelText: 'Número da Nota',
                  validator: Validators.required,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _serieController,
                  labelText: 'Série',
                  validator: Validators.required,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomDatePicker(
                  controller: _dataEmissaoController,
                  labelText: 'Data de Emissão',
                  validator: Validators.required,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _valorTotalController,
                  labelText: 'Valor Total',
                  validator: Validators.positiveNumber,
                  keyboardType: TextInputType.number,
                  inputFormatters: [Formatters.decimalInputFormatter],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _cnpjEmitenteController,
                  labelText: 'CNPJ do Emitente',
                  validator: Validators.cnpj,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _razaoSocialEmitenteController,
                  labelText: 'Razão Social do Emitente',
                  validator: Validators.required,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _cnpjDestinatarioController,
                  labelText: 'CNPJ do Destinatário (opcional)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _chaveAcessoController,
                  labelText: 'Chave de Acesso (opcional)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () { /* Lógica de anexar PDF (UI apenas) */ },
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Anexar PDF'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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