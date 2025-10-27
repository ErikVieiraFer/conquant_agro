import 'package:conquant_agro/data/models/categoria_historico.dart';
import 'package:conquant_agro/presentation/controllers/categoria_historico_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriaHistoricoForm extends StatefulWidget {
  const CategoriaHistoricoForm({super.key});

  @override
  State<CategoriaHistoricoForm> createState() => _CategoriaHistoricoFormState();
}

class _CategoriaHistoricoFormState extends State<CategoriaHistoricoForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  CategoriaHistorico? get categoria => Get.arguments as CategoriaHistorico?;
  final CategoriaHistoricoController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    if (categoria != null) {
      _nomeController.text = categoria!.nome;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoria == null ? 'Nova Categoria' : 'Editar Categoria'),
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
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final novaCategoria = CategoriaHistorico(
                    id: categoria?.id ?? '',
                    nome: _nomeController.text,
                  );
                  if (categoria == null) {
                    _controller.addCategoriaHistorico(novaCategoria);
                  } else {
                    _controller.updateCategoriaHistorico(novaCategoria);
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
