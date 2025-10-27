import 'package:conquant_agro/data/models/movimentacao.dart';
import 'package:conquant_agro/presentation/controllers/movimentacao_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MovimentacaoForm extends StatefulWidget {
  const MovimentacaoForm({super.key});

  @override
  State<MovimentacaoForm> createState() => _MovimentacaoFormState();
}

class _MovimentacaoFormState extends State<MovimentacaoForm> {
  final _formKey = GlobalKey<FormState>();
  final _gadoIdController = TextEditingController();
  final _pastoOrigemIdController = TextEditingController();
  final _pastoDestinoIdController = TextEditingController();
  DateTime _data = DateTime.now();

  Movimentacao? get movimentacao => Get.arguments as Movimentacao?;
  final MovimentacaoController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    if (movimentacao != null) {
      _gadoIdController.text = movimentacao!.gadoId;
      _pastoOrigemIdController.text = movimentacao!.pastoOrigemId;
      _pastoDestinoIdController.text = movimentacao!.pastoDestinoId;
      _data = movimentacao!.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movimentacao == null ? 'Nova Movimentação' : 'Editar Movimentação'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _gadoIdController,
              decoration: const InputDecoration(labelText: 'ID do Gado'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O ID do gado é obrigatório.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _pastoOrigemIdController,
              decoration: const InputDecoration(labelText: 'ID do Pasto de Origem'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O ID do pasto de origem é obrigatório.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _pastoDestinoIdController,
              decoration: const InputDecoration(labelText: 'ID do Pasto de Destino'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O ID do pasto de destino é obrigatório.';
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
                  final novaMovimentacao = Movimentacao(
                    id: movimentacao?.id ?? '',
                    gadoId: _gadoIdController.text,
                    pastoOrigemId: _pastoOrigemIdController.text,
                    pastoDestinoId: _pastoDestinoIdController.text,
                    data: _data,
                  );
                  if (movimentacao == null) {
                    _controller.addMovimentacao(novaMovimentacao);
                  } else {
                    _controller.updateMovimentacao(novaMovimentacao);
                  }
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