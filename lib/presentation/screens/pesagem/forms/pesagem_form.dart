import 'package:conquant_agro/data/models/gado.dart';
import 'package:conquant_agro/data/models/pesagem.dart';
import 'package:conquant_agro/presentation/controllers/gado_controller.dart';
import 'package:conquant_agro/presentation/controllers/pesagem_controller.dart';
import 'package:conquant_agro/presentation/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class PesagemForm extends StatefulWidget {
  const PesagemForm({super.key});

  @override
  State<PesagemForm> createState() => _PesagemFormState();
}

class _PesagemFormState extends State<PesagemForm> {
  final _formKey = GlobalKey<FormState>();
  final _pesoController = TextEditingController();
  DateTime _data = DateTime.now();
  Gado? _selectedGado;

  final pesagemController = Get.find<PesagemController>();
  final gadoController = Get.find<GadoController>();

  Pesagem? get pesagem => Get.arguments as Pesagem?;

  @override
  void initState() {
    super.initState();
    if (pesagem != null) {
      _selectedGado = gadoController.gados.firstWhereOrNull((g) => g.id == pesagem!.gadoId);
      _pesoController.text = pesagem!.peso.toString();
      _data = pesagem!.data;
    }
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      if (pesagem == null) {
        // Adicionar nova pesagem
        final novaPesagem = Pesagem(
          id: const Uuid().v4(),
          gadoId: _selectedGado!.id,
          data: _data,
          peso: double.parse(_pesoController.text),
        );
        pesagemController.adicionarPesagem(novaPesagem);
      } else {
        // Editar pesagem existente
        final pesagemEditada = Pesagem(
          id: pesagem!.id,
          gadoId: _selectedGado!.id,
          data: _data,
          peso: double.parse(_pesoController.text),
        );
        pesagemController.editarPesagem(pesagemEditada);
      }
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pesagem == null ? 'Nova Pesagem' : 'Editar Pesagem'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomDropdown<Gado>(
              items: gadoController.gados,
              labelText: 'Gado',
              selectedItem: _selectedGado,
              onChanged: (gado) {
                setState(() {
                  _selectedGado = gado;
                });
              },
              itemAsString: (gado) => gado.brinco,
              validator: (gado) {
                if (gado == null) {
                  return 'Selecione um gado.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pesoController,
              decoration: const InputDecoration(labelText: 'Peso (kg)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O peso é obrigatório.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Data'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(_data)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final data = await showDatePicker(
                  context: context,
                  initialDate: _data,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (data != null) {
                  setState(() {
                    _data = data;
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
