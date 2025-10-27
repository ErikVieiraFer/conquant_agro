import 'package:conquant_agro/data/models/pesagem_grupo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PesagemGrupoForm extends StatefulWidget {
  const PesagemGrupoForm({super.key});

  @override
  State<PesagemGrupoForm> createState() => _PesagemGrupoFormState();
}

class _PesagemGrupoFormState extends State<PesagemGrupoForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  DateTime _data = DateTime.now();

  PesagemGrupo? get grupo => Get.arguments as PesagemGrupo?;

  @override
  void initState() {
    super.initState();
    if (grupo != null) {
      _nomeController.text = grupo!.nome;
      _data = grupo!.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(grupo == null ? 'Novo Grupo' : 'Editar Grupo'),
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
            ListTile(
              title: const Text('Data'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(_data)),
              onTap: () async {
                final data = await showDatePicker(
                  context: context,
                  initialDate: _data,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (data != null) {
                  setState(() {
                    _data = data;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Implement save group
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
