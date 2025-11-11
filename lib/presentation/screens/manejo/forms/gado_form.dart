import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/gado.dart';
import '../../../../data/models/pasto.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/gado_controller.dart';
import '../../../controllers/pasto_controller.dart';

class GadoForm extends StatefulWidget {
  const GadoForm({super.key});

  @override
  State<GadoForm> createState() => _GadoFormState();
}

class _GadoFormState extends State<GadoForm> {
  final _formKey = GlobalKey<FormState>();
  final formatDate = DateFormat('dd/MM/yyyy');

  // Controllers de texto
  final _idEletronicoController = TextEditingController();
  final _idUsualController = TextEditingController();
  final _grauSangueController = TextEditingController();
  final _rgnRgdController = TextEditingController();
  final _loteEntradaController = TextEditingController();
  final _loteSaidaController = TextEditingController();

  // Valores selecionados
  String? _racaSelecionada;
  String? _sexoSelecionado;
  String? _pelagemSelecionada;
  DateTime _dataNascimento = DateTime.now();
  Pasto? _pastoSelecionado;

  Gado? get gado => Get.arguments as Gado?;
  final GadoController _gadoController = Get.find();
  final PastoController _pastoController = Get.find();
  final AuthController _authController = Get.find();

  final List<String> _sexos = ['Macho', 'Fêmea'];

  @override
  void initState() {
    super.initState();

    // Preencher formulário se for edição
    if (gado != null) {
      _idEletronicoController.text = gado!.idEletronico ?? '';
      _idUsualController.text = gado!.idUsual;
      _racaSelecionada = gado!.raca;
      _grauSangueController.text = gado!.grauSangue?.toString() ?? '';
      _sexoSelecionado = gado!.sexo;
      _pelagemSelecionada = gado!.pelagem;
      _dataNascimento = gado!.dataNascimento;
      _rgnRgdController.text = gado!.rgnRgd ?? '';
      _loteEntradaController.text = gado!.loteEntrada ?? '';
      _loteSaidaController.text = gado!.loteSaida ?? '';

      if (gado!.pastoId != null) {
        _pastoSelecionado =
            _pastoController.pastos.firstWhereOrNull((p) => p.id == gado!.pastoId);
      }
    }
  }

  @override
  void dispose() {
    _idEletronicoController.dispose();
    _idUsualController.dispose();
    _grauSangueController.dispose();
    _rgnRgdController.dispose();
    _loteEntradaController.dispose();
    _loteSaidaController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataNascimento,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _dataNascimento) {
      setState(() {
        _dataNascimento = picked;
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final propriedadeId = _authController.propriedadeAtual.value?.id ?? '';
    if (propriedadeId.isEmpty) {
      Get.snackbar(
        'Erro',
        'Propriedade não identificada',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final novoGado = Gado(
      id: gado?.id,
      propriedadeId: propriedadeId,
      idEletronico: _idEletronicoController.text.trim().isNotEmpty
          ? _idEletronicoController.text.trim()
          : null,
      idUsual: _idUsualController.text.trim(),
      raca: _racaSelecionada!,
      grauSangue: _grauSangueController.text.trim().isNotEmpty
          ? double.parse(_grauSangueController.text.trim())
          : null,
      sexo: _sexoSelecionado!,
      pelagem: _pelagemSelecionada,
      dataNascimento: _dataNascimento,
      rgnRgd: _rgnRgdController.text.trim().isNotEmpty
          ? _rgnRgdController.text.trim()
          : null,
      loteEntrada: _loteEntradaController.text.trim().isNotEmpty
          ? _loteEntradaController.text.trim()
          : null,
      loteSaida: _loteSaidaController.text.trim().isNotEmpty
          ? _loteSaidaController.text.trim()
          : null,
      pastoId: _pastoSelecionado?.id,
    );

    bool sucesso;
    if (gado == null) {
      sucesso = await _gadoController.criarGado(novoGado);
    } else {
      sucesso = await _gadoController.atualizarGado(novoGado);
    }

    if (sucesso) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gado == null ? 'Novo Gado' : 'Editar Gado'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Seção: Identificação
            const Text(
              'IDENTIFICAÇÃO',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),

            // ID Eletrônico (RFID)
            TextFormField(
              controller: _idEletronicoController,
              decoration: const InputDecoration(
                labelText: 'ID Eletrônico (RFID)',
                hintText: 'RFID123456',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.sensors),
              ),
            ),
            const SizedBox(height: 16),

            // ID Usual (Brinco) - OBRIGATÓRIO
            TextFormField(
              controller: _idUsualController,
              decoration: const InputDecoration(
                labelText: 'ID Usual (Brinco) *',
                hintText: 'BR001',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.tag),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'ID Usual é obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // RGN/RGD
            TextFormField(
              controller: _rgnRgdController,
              decoration: const InputDecoration(
                labelText: 'RGN/RGD (Registro Genealógico)',
                hintText: 'RGN123456',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.assignment),
              ),
            ),
            const SizedBox(height: 24),

            // Seção: Características
            const Text(
              'CARACTERÍSTICAS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Raça - OBRIGATÓRIO
            Obx(() => DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Raça *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.pets),
                  ),
                  value: _racaSelecionada,
                  items: _gadoController.racas.map((raca) {
                    return DropdownMenuItem(
                      value: raca,
                      child: Text(raca),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _racaSelecionada = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Raça é obrigatória';
                    }
                    return null;
                  },
                )),
            const SizedBox(height: 16),

            // Grau de Sangue
            TextFormField(
              controller: _grauSangueController,
              decoration: const InputDecoration(
                labelText: 'Grau de Sangue',
                hintText: '0 a 100',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.water_drop),
                suffixText: '%',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  final grau = double.tryParse(value);
                  if (grau == null || grau < 0 || grau > 100) {
                    return 'Grau deve estar entre 0 e 100';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Sexo - OBRIGATÓRIO
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Sexo *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.wc),
              ),
              value: _sexoSelecionado,
              items: _sexos.map((sexo) {
                return DropdownMenuItem(
                  value: sexo,
                  child: Text(sexo),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _sexoSelecionado = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Sexo é obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Pelagem
            Obx(() => DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Pelagem',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.palette),
                  ),
                  value: _pelagemSelecionada,
                  items: _gadoController.pelagens.map((pelagem) {
                    return DropdownMenuItem(
                      value: pelagem,
                      child: Text(pelagem),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _pelagemSelecionada = value;
                    });
                  },
                )),
            const SizedBox(height: 16),

            // Data de Nascimento - OBRIGATÓRIO
            InkWell(
              onTap: _selecionarData,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(formatDate.format(_dataNascimento)),
              ),
            ),
            const SizedBox(height: 24),

            // Seção: Localização
            const Text(
              'LOCALIZAÇÃO',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Pasto
            Obx(() => DropdownButtonFormField<Pasto>(
                  decoration: const InputDecoration(
                    labelText: 'Pasto',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.grass),
                  ),
                  value: _pastoSelecionado,
                  items: _pastoController.pastos.map((pasto) {
                    return DropdownMenuItem(
                      value: pasto,
                      child: Text(pasto.nome),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _pastoSelecionado = value;
                    });
                  },
                )),
            const SizedBox(height: 24),

            // Seção: Lotes
            const Text(
              'LOTES',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Lote de Entrada
            TextFormField(
              controller: _loteEntradaController,
              decoration: const InputDecoration(
                labelText: 'Lote de Entrada',
                hintText: 'LOTE2025-01',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.input),
              ),
            ),
            const SizedBox(height: 16),

            // Lote de Saída
            TextFormField(
              controller: _loteSaidaController,
              decoration: const InputDecoration(
                labelText: 'Lote de Saída',
                hintText: 'LOTE2025-02',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.output),
              ),
            ),
            const SizedBox(height: 24),

            // Botão Salvar
            Obx(() => ElevatedButton.icon(
                  onPressed: _gadoController.isLoading.value ? null : _salvar,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: _gadoController.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check),
                  label: Text(gado == null ? 'Cadastrar' : 'Atualizar'),
                )),
          ],
        ),
      ),
    );
  }
}
