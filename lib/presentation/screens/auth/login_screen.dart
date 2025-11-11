import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../../core/constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authController = Get.find<AuthController>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _authController.login(
        _emailController.text.trim(),
        _senhaController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Nome do App
                  Image.asset(
                    'assets/icons/ConOuant_boi.png',
                    height: 120, // Ajuste o tamanho conforme necessário
                  ),
                  const SizedBox(height: 24),
                  
                  const Text(
                    'ConQuant Agro',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  const Text(
                    'Gestão de Fazendas',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Campo Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite seu email';
                      }
                      if (!value.contains('@')) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo Senha
                  TextFormField(
                    controller: _senhaController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite sua senha';
                      }
                      if (value.length < 6) {
                        return 'Senha deve ter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Botão Login
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _authController.isLoading.value
                          ? null
                          : _handleLogin,
                      child: _authController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Entrar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  )),
                  const SizedBox(height: 16),
                  
                  // Esqueci minha senha
                  TextButton(
                    onPressed: () {
                      Get.snackbar(
                        'Em desenvolvimento',
                        'Funcionalidade será implementada em breve',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: const Text('Esqueci minha senha'),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Credenciais de teste
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.info.withAlpha((255 * 0.1).round()),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.info.withAlpha((255 * 0.3).round())),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'Credenciais de Teste:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.info,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Email: admin@conquant.com.br',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Senha: 123456',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}