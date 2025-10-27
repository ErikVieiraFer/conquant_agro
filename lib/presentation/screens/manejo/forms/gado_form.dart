import 'package:conquant_agro/data/models/gado.dart';
import 'package:conquant_agro/data/models/pasto.dart';
import 'package:conquant_agro/presentation/controllers/auth_controller.dart';
import 'package:conquant_agro/presentation/controllers/gado_controller.dart';
import 'package:conquant_agro/presentation/controllers/pasto_controller.dart';
import 'package:conquant_agro/presentation/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class GadoForm extends StatefulWidget {
  const GadoForm({super.key});

  @override
  State<GadoForm> createState() => _GadoFormState();
}

class _GadoFormState extends State<GadoForm> {
  final _formKey = GlobalKey<FormState>();
  final _brincoController = TextEditingController();
  final _racaController = TextEditingController();
  DateTime _dataNascimento = DateTime.now();
  Pasto? _selectedPasto;

  Gado? get gado => Get.arguments as Gado?;
  final GadoController _controller = Get.find();
  final PastoController _pastoController = Get.find();
  final AuthController _authController = Get.find();

  @override
  void initState() {
    super.initState();
    if (gado != null) {
      _brincoController.text = gado!.brinco;
      _racaController.text = gado!.raca;
      _dataNascimento = gado!.dataNascimento;
      _selectedPasto = _pastoController.pastos.firstWhereOrNull((p) => p.id == gado!.pastoId);
    }
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final idPropriedade = _authController.propriedadeAtual.value!.id;
      if (gado == null) {
        final novoGado = Gado(
          id: const Uuid().v4(),
          brinco: _brincoController.text,
          raca: _racaController.text,
          dataNascimento: _dataNascimento,
          pastoId: _selectedPasto!.id,
          idPropriedade: idPropriedade,
        );
        _controller.addGado(novoGado);
      } else {
        final gadoEditado = Gado(
          id: gado!.id,
          brinco: _brincoController.text,
          raca: _racaController.text,
          dataNascimento: _dataNascimento,
          pastoId: _selectedPasto!.id,
          idPropriedade: idPropriedade,
        );
        _controller.updateGado(gadoEditado);
      }
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
            TextFormField(
              controller: _brincoController,
              decoration: const InputDecoration(labelText: 'Brinco'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O brinco é obrigatório.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _racaController,
              decoration: const InputDecoration(labelText: 'Raça'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'A raça é obrigatória.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomDropdown<Pasto>(
              items: _pastoController.pastos,
              labelText: 'Pasto',
              selectedItem: _selectedPasto,
              onChanged: (pasto) {
                setState(() {
                  _selectedPasto = pasto;
                });
              },
              itemAsString: (pasto) => pasto.nome,
              validator: (pasto) {
                if (pasto == null) {
                  return 'Selecione um pasto.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Data de Nascimento'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(_dataNascimento)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final data = await showDatePicker(
                  context: context,
                  initialDate: _dataNascimento,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (data != null) {
                  setState(() {
                    _dataNascimento = data;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}