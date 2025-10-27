import 'package:conquant_agro/data/mock/cliente_mock.dart';
import 'package:conquant_agro/data/models/cliente.dart';
import 'package:get/get.dart';

class ClienteController extends GetxController {
  final RxList<Cliente> clientes = <Cliente>[].obs;

  @override
  void onInit() {
    super.onInit();
    carregarClientes();
  }

  void carregarClientes() {
    clientes.value = ClienteMockData.clientes;
  }
}
