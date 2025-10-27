import 'package:conquant_agro/data/models/movimentacao_gado.dart';
import 'package:conquant_agro/presentation/controllers/movimentacao_gado_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MovimentacaoGadoForm extends StatefulWidget {
  const MovimentacaoGadoForm({super.key});

  @override
  State<MovimentacaoGadoForm> createState() => _MovimentacaoGadoFormState();
}

class _MovimentacaoGadoFormState extends State<MovimentacaoGadoForm> {
  final _formKey = GlobalKey<FormState>();
  final _pastoOrigemIdController = TextEditingController();
  final _pastoDestinoIdController = TextEditingController();
  DateTime _data = DateTime.now();

  String get gadoId => Get.arguments as String;
  final MovimentacaoGadoController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Movimentação do Gado'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
                  final novaMovimentacao = MovimentacaoGado(
                    id: '',
                    gadoId: gadoId,
                    pastoOrigemId: _pastoOrigemIdController.text,
                    pastoDestinoId: _pastoDestinoIdController.text,
                    data: _data,
                  );
                  _controller.addMovimentacaoGado(novaMovimentacao);
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
