import 'package:conquant_agro/core/constants/permissoes.dart';
import 'package:conquant_agro/data/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsuarioForm extends StatefulWidget {
  const UsuarioForm({super.key});

  @override
  State<UsuarioForm> createState() => _UsuarioFormState();
}

class _UsuarioFormState extends State<UsuarioForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  Permissao _permissao = Permissao.operacao;
  bool _ativo = true;

  Usuario? get usuario => Get.arguments as Usuario?;

  @override
  void initState() {
    super.initState();
    if (usuario != null) {
      _nomeController.text = usuario!.nome;
      _emailController.text = usuario!.email;
      _permissao = usuario!.permissao;
      _ativo = usuario!.ativo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(usuario == null ? 'Novo Usuário' : 'Editar Usuário'),
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
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O email é obrigatório.';
                }
                return null;
              },
            ),
            DropdownButtonFormField<Permissao>(
              value: _permissao,
              decoration: const InputDecoration(labelText: 'Permissão'),
              items: Permissao.values.map((permissao) {
                return DropdownMenuItem(
                  value: permissao,
                  child: Text(permissao.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _permissao = value!;
                });
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Implement save usuario
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