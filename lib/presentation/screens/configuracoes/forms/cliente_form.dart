import 'package:conquant_agro/data/models/cliente.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ClienteForm extends StatefulWidget {
  const ClienteForm({super.key});

  @override
  State<ClienteForm> createState() => _ClienteFormState();
}

class _ClienteFormState extends State<ClienteForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cnpjController = TextEditingController();
  bool _ativo = true;
  DateTime _dataVencimento = DateTime.now();

  Cliente? get cliente => Get.arguments as Cliente?;

  @override
  void initState() {
    super.initState();
    if (cliente != null) {
      _nomeController.text = cliente!.nome;
      _cnpjController.text = cliente!.cnpj;
      _ativo = cliente!.ativo;
      _dataVencimento = cliente!.dataVencimento;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cliente == null ? 'Novo Cliente' : 'Editar Cliente'),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O CNPJ é obrigatório.';
                }
                return null;
              },
            ),
            SwitchListTile(
              title: const Text('Ativo'),
              value: _ativo,
              onChanged: (value) {
                setState(() {
                  _ativo = value;
                });
              },
            ),
            ListTile(
              title: const Text('Data de Vencimento'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(_dataVencimento)),
              onTap: () async {
                final data = await showDatePicker(
                  context: context,
                  initialDate: _dataVencimento,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (data != null) {
                  setState(() {
                    _dataVencimento = data;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Implement save client
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
