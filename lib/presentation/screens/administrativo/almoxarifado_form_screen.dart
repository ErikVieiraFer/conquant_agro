import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/almoxarifado.dart';
import '../../controllers/almoxarifado_controller.dart';

class AlmoxarifadoFormScreen extends StatefulWidget {
  const AlmoxarifadoFormScreen({super.key});

  @override
  State<AlmoxarifadoFormScreen> createState() => _AlmoxarifadoFormScreenState();
}

class _AlmoxarifadoFormScreenState extends State<AlmoxarifadoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<AlmoxarifadoController>();

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _unidadeController = TextEditingController();

  SistemaEstoque _sistemaSelecionado = SistemaEstoque.peps;
  Almoxarifado? materialEdicao;
  bool isEdicao = false;

  @override
  void initState() {
    super.initState();

    // Verificar se é edição (recebe material como argumento)
    if (Get.arguments != null && Get.arguments is Almoxarifado) {
      materialEdicao = Get.arguments as Almoxarifado;
      isEdicao = true;
      _preencherFormulario();
    }
  }

  void _preencherFormulario() {
    if (materialEdicao != null) {
      _nomeController.text = materialEdicao!.nome;
      _descricaoController.text = materialEdicao!.descricao ?? '';
      _unidadeController.text = materialEdicao!.unidade;
      _sistemaSelecionado = materialEdicao!.sistema;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _unidadeController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final material = Almoxarifado(
      id: isEdicao ? materialEdicao!.id : null,
      propriedadeId: controller.propriedadeIdAtual.value,
      nome: _nomeController.text.trim(),
      descricao: _descricaoController.text.trim(),
      unidade: _unidadeController.text.trim(),
      sistema: _sistemaSelecionado,
    );

    bool sucesso;
    if (isEdicao) {
      sucesso = await controller.atualizarMaterial(material);
    } else {
      sucesso = await controller.criarMaterial(material);
    }

    if (sucesso) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Material' : 'Novo Material'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Material *',
                hintText: 'Ex: Ração Premium, Adubo NPK',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nome é obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                hintText: 'Descrição detalhada do material',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _unidadeController,
              decoration: const InputDecoration(
                labelText: 'Unidade de Medida *',
                hintText: 'Ex: kg, L, unidade, saca',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Unidade é obrigatória';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Sistema de Controle de Estoque',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  RadioListTile<SistemaEstoque>(
                    title: const Text('PEPS - Primeiro a Entrar, Primeiro a Sair'),
                    subtitle: const Text(
                      'Nas saídas, consome os lotes mais antigos primeiro',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: SistemaEstoque.peps,
                    groupValue: _sistemaSelecionado,
                    onChanged: (value) {
                      setState(() {
                        _sistemaSelecionado = value!;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<SistemaEstoque>(
                    title: const Text('UEPS - Último a Entrar, Primeiro a Sair'),
                    subtitle: const Text(
                      'Nas saídas, consome os lotes mais recentes primeiro',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: SistemaEstoque.ueps,
                    groupValue: _sistemaSelecionado,
                    onChanged: (value) {
                      setState(() {
                        _sistemaSelecionado = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : _salvar,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEdicao ? 'Atualizar' : 'Cadastrar'),
                )),
          ],
        ),
      ),
    );
  }
}
