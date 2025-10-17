import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/usuario.dart';
import '../../data/models/propriedade.dart';
import '../../data/mock/mock_data.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final Rx<Usuario?> usuarioAtual = Rx<Usuario?>(null);
  final Rx<Propriedade?> propriedadeAtual = Rx<Propriedade?>(null);
  final RxBool isLoading = false.obs;

  bool get isLogado => usuarioAtual.value != null;

  @override
  void onInit() {
    super.onInit();
    // Aguarda o frame ser construído antes de navegar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verificarLoginSalvo();
    });
  }

  Future<void> _verificarLoginSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    final emailSalvo = prefs.getString('email');
    
    if (emailSalvo != null) {
      final usuario = MockData.getUsuarioPorEmail(emailSalvo);
      if (usuario != null) {
        usuarioAtual.value = usuario;
        propriedadeAtual.value = MockData.propriedades
            .firstWhere((p) => p.id == usuario.propriedadeId);
        Get.offAllNamed(AppRoutes.home);
      }
    }
  }

  Future<void> login(String email, String senha) async {
    try {
      isLoading.value = true;

      // Simular delay de rede
      await Future.delayed(const Duration(seconds: 1));

      if (MockData.validarLogin(email, senha)) {
        final usuario = MockData.getUsuarioPorEmail(email);
        if (usuario != null) {
          usuarioAtual.value = usuario;
          propriedadeAtual.value = MockData.propriedades
              .firstWhere((p) => p.id == usuario.propriedadeId);

          // Salvar login
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', email);

          Get.offAllNamed(AppRoutes.home);
          Get.snackbar(
            'Sucesso',
            'Bem-vindo, ${usuario.nome}!',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Erro',
          'Email ou senha inválidos',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    usuarioAtual.value = null;
    propriedadeAtual.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}