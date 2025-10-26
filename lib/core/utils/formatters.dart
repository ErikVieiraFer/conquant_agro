
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Formatters {
  static final TextInputFormatter decimalInputFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'));

  static String date(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String currency(double value) {
    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatador.format(value);
  }

  static String cpf(String cpf) {
    return cpf.replaceAllMapped(
        RegExp(r'(\d{3})(\d{3})(\d{3})(\d{2})'),
        (Match m) => "${m[1]}.${m[2]}.${m[3]}-${m[4]}");
  }

  static String cnpj(String cnpj) {
    return cnpj.replaceAllMapped(
        RegExp(r'(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})'),
        (Match m) => "${m[1]}.${m[2]}.${m[3]}/${m[4]}-${m[5]}");
  }

  static String phone(String phone) {
    if (phone.length == 11) {
      return phone.replaceAllMapped(
          RegExp(r'(\d{2})(\d{5})(\d{4})'),
          (Match m) => "(${m[1]}) ${m[2]}-${m[3]}");
    }
    return phone;
  }
}
