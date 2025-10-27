import 'package:conquant_agro/data/models/pasto.dart';
import 'package:conquant_agro/presentation/controllers/auth_controller.dart';
import 'package:conquant_agro/presentation/controllers/pasto_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class PastoForm extends StatefulWidget {
  const PastoForm({super.key});

  @override
  State<PastoForm> createState() => _PastoFormState();
}

class _PastoFormState extends State<PastoForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _areaController = TextEditingController();

  Pasto? get pasto => Get.arguments as Pasto?;
  final PastoController _controller = Get.find();
  final AuthController _authController = Get.find();

  @override
  void initState() {
    super.initState();
    if (pasto != null) {
      _nomeController.text = pasto!.nome;
      _areaController.text = pasto!.area.toString();
    }
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final idPropriedade = _authController.propriedadeAtual.value!.id;
      if (pasto == null) {
        final novoPasto = Pasto(
          id: const Uuid().v4(),
          nome: _nomeController.text,
          area: double.tryParse(_areaController.text) ?? 0,
          idPropriedade: idPropriedade,
        );
        _controller.addPasto(novoPasto);
      } else {
        final pastoEditado = Pasto(
          id: pasto!.id,
          nome: _nomeController.text,
          area: double.tryParse(_areaController.text) ?? 0,
          idPropriedade: idPropriedade,
        );
        _controller.updatePasto(pastoEditado);
      }
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pasto == null ? 'Novo Pasto' : 'Editar Pasto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O nome é obrigatório.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _areaController,
              decoration: const InputDecoration(labelText: 'Área (ha)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'A área é obrigatória.';
                }
                return null;
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