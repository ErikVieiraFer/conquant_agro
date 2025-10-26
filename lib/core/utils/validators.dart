
import 'package:get/get.dart';

class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo de email é obrigatório.';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Por favor, insira um email válido.';
    }
    return null;
  }

  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório.';
    }
    return null;
  }

  static String? cpf(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo de CPF é obrigatório.';
    }
    if (!GetUtils.isCpf(value)) {
      return 'CPF inválido.';
    }
    return null;
  }

  static String? cnpj(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo de CNPJ é obrigatório.';
    }
    if (!GetUtils.isCnpj(value)) {
      return 'CNPJ inválido.';
    }
    return null;
  }

  static String? minLength(String? value, int min) {
    if (value == null || value.length < min) {
      return 'Deve ter no mínimo $min caracteres.';
    }
    return null;
  }

  static String? positiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório.';
    }
    final number = double.tryParse(value.replaceAll('.', '').replaceAll(',', '.'));
    if (number == null || number <= 0) {
      return 'O valor deve ser maior que zero.';
    }
    return null;
  }
}
