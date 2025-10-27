import 'package:conquant_agro/data/models/propriedade.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropriedadeForm extends StatefulWidget {
  const PropriedadeForm({super.key});

  @override
  State<PropriedadeForm> createState() => _PropriedadeFormState();
}

class _PropriedadeFormState extends State<PropriedadeForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _enderecoController = TextEditingController();
  bool _bloqueado = false;

  Propriedade? get propriedade => Get.arguments as Propriedade?;

  @override
  void initState() {
    super.initState();
    if (propriedade != null) {
      _nomeController.text = propriedade!.nome;
      _cnpjController.text = propriedade!.cnpj ?? '';
      _enderecoController.text = propriedade!.endereco ?? '';
      _bloqueado = propriedade!.bloqueado;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(propriedade == null ? 'Nova Propriedade' : 'Editar Propriedade'),
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
            TextFormField(
              controller: _cnpjController,
              decoration: const InputDecoration(labelText: 'CNPJ'),
            ),
            TextFormField(
              controller: _enderecoController,
              decoration: const InputDecoration(labelText: 'Endereço'),
            ),
            SwitchListTile(
              title: const Text('Bloqueado'),
              value: _bloqueado,
              onChanged: (value) {
                setState(() {
                  _bloqueado = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Implement save propriedade
                  Get.back();
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}